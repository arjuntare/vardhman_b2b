import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vardhman_b2b/api/api.dart';
import 'package:vardhman_b2b/api/invoice_info.dart';
import 'package:vardhman_b2b/constants.dart';
import 'package:vardhman_b2b/user/user_controller.dart';

class InvoicesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _userController = Get.find<UserController>(tag: 'userController');

  final _rxInvoiceInfos = RxList<InvoiceInfo>();

  final rxEarliestInvoiceDate = oldestDateTime.obs;

  final rxInvoiceFromDate = oldestDateTime.obs;

  final rxInvoiceToDate = DateTime.now().obs;

  final rxEarliestReceiptDate = oldestDateTime.obs;

  final rxReceiptFromDate = oldestDateTime.obs;

  final rxReceiptToDate = DateTime.now().obs;

  final rxInvoiceNumberInput = ''.obs;

  final rxSelectedInvoiceInfos = <InvoiceInfo>[].obs;

  final invoiceNumberTextEditingController = TextEditingController();

  final invoicesOlderThanTextEditingController = TextEditingController();

  final rxAdvancePaymentAmount = 0.0.obs;

  final advancePaymentInputController = TextEditingController(
    text: '0',
  );

  late final tabController = TabController(
    length: 3,
    vsync: this,
  );

  DateTime? previousFromDate;

  InvoicesController() {
    init();
  }

  Future<void> init() async {
    _userController.rxCustomerDetail.listenAndPump(
      (_) async {
        await refreshInvoices();

        clearOpenFilters();

        clearPaidFilters();
      },
    );
  }

  Future<void> refreshInvoices() async {
    final customerSoldToNumber =
        _userController.rxCustomerDetail.value.soldToNumber;

    final invoiceInfos = await Api.fetchInvoices(
      customerNumber: customerSoldToNumber,
      company: _userController.rxCustomerDetail.value.companyCode,
    );

    if (invoiceInfos.isNotEmpty) {
      final invoicesInProcessing =
          await Api.fetchInvoicesInProcessing(customerSoldToNumber);

      final processedInvoiceInfos = invoiceInfos.map(
        (invoiceInfo) {
          InvoiceInfo processedInvoiceInfo =
              getInvoiceInfoWithStatusAndDiscount(invoiceInfo);

          if (invoiceInfo.isOpen &&
              invoicesInProcessing.contains(invoiceInfo.invoiceNumber)) {
            processedInvoiceInfo = processedInvoiceInfo.copyWith(
              status: InvoiceStatus.processing,
            );
          }

          return processedInvoiceInfo;
        },
      ).toList();

      _rxInvoiceInfos.clear();

      processedInvoiceInfos.sort(
        (a, b) => a.date.compareTo(b.date) == 0
            ? a.invoiceNumber.compareTo(b.invoiceNumber)
            : a.date.compareTo(b.date),
      );

      _rxInvoiceInfos.addAll(processedInvoiceInfos);

      rxEarliestInvoiceDate.value =
          openInvoices.isEmpty ? oldestDateTime : openInvoices.first.date;

      rxEarliestReceiptDate.value =
          paidInvoices.isEmpty ? oldestDateTime : paidInvoices.last.receiptDate;
    } else {
      _rxInvoiceInfos.clear();

      rxEarliestInvoiceDate.value = oldestDateTime;

      rxEarliestReceiptDate.value = oldestDateTime;
    }
  }

  List<InvoiceInfo> get creditNotes => filteredOpenInvoices
      .where(
        (invoiceInfo) => invoiceInfo.status == InvoiceStatus.creditNote,
      )
      .toList();

  List<InvoiceInfo> get overdueInvoices => filteredOpenInvoices
      .where(
        (invoiceInfo) => invoiceInfo.status == InvoiceStatus.overdue,
      )
      .toList();

  List<InvoiceInfo> get notDueInvoices => filteredOpenInvoices
      .where(
        (invoiceInfo) => invoiceInfo.status == InvoiceStatus.notDue,
      )
      .toList();

  List<InvoiceInfo> get dueInvoices => [
        ...notDueInvoices,
        ...discountedInvoices,
        ...heldInvoices,
      ];

  List<InvoiceInfo> get discountedInvoices => filteredOpenInvoices
      .where(
        (invoiceInfo) => invoiceInfo.status == InvoiceStatus.discounted,
      )
      .toList();

  List<InvoiceInfo> get processingInvoices => filteredOpenInvoices
      .where(
        (invoiceInfo) => invoiceInfo.status == InvoiceStatus.processing,
      )
      .toList();

  List<InvoiceInfo> get heldInvoices => filteredOpenInvoices
      .where(
        (invoiceInfo) => invoiceInfo.status == InvoiceStatus.onHold,
      )
      .toList();

  void addInvoiceToSelected(InvoiceInfo invoiceInfo) {
    if (!rxSelectedInvoiceInfos.contains(invoiceInfo)) {
      rxSelectedInvoiceInfos.add(invoiceInfo);

      rxSelectedInvoiceInfos.sort(
        (a, b) => a.discountDueDate.compareTo(b.discountDueDate) == 0
            ? a.invoiceNumber.compareTo(b.invoiceNumber)
            : a.discountDueDate.compareTo(b.discountDueDate),
      );
    }
  }

  void removeInvoiceFromSelected(InvoiceInfo invoiceInfo) {
    rxSelectedInvoiceInfos.remove(invoiceInfo);
  }

  double getTotalAmount(InvoiceStatus invoiceStatus) {
    return _rxInvoiceInfos
        .fold(
          0.0,
          (previousValue, invoiceInfo) =>
              previousValue +
              (invoiceInfo.status == invoiceStatus
                  ? invoiceInfo.openAmount
                  : 0),
        )
        .toPrecision(2);
  }

  double get totalOverdueAmount => getTotalAmount(InvoiceStatus.overdue);

  double get totalNotDueAmount => getTotalAmount(InvoiceStatus.notDue);

  double get totalCreditNoteAmount => getTotalAmount(InvoiceStatus.creditNote);

  double get totalDiscountedAmount => getTotalAmount(InvoiceStatus.discounted);

  double get totalProcessingAmount => getTotalAmount(InvoiceStatus.processing);

  double get totalHeldAmount => getTotalAmount(InvoiceStatus.onHold);

  List<InvoiceInfo> get openInvoices => _rxInvoiceInfos
      .where((invoiceInfo) => invoiceInfo.status != InvoiceStatus.paid)
      .toList();

  double get totalOpenAmount => openInvoices
      .where(
        (invoiceInfo) =>
            invoiceInfo.status != InvoiceStatus.processing &&
            invoiceInfo.status != InvoiceStatus.creditNote,
      )
      .fold(
        0.0,
        (previousValue, invoiceInfo) =>
            previousValue +
            (invoiceInfo.status == InvoiceStatus.discounted
                ? invoiceInfo.discountAmount
                : invoiceInfo.openAmount),
      )
      .toPrecision(2);

  double get selectedTotalAmount => rxSelectedInvoiceInfos
      .fold(
        0.0,
        (previousValue, element) => previousValue + element.openAmount,
      )
      .toPrecision(2);

  double get selectedDiscountedAmount => rxSelectedInvoiceInfos.fold(
        0.0,
        (previousValue, invoiceInfo) {
          if (invoiceInfo.status == InvoiceStatus.discounted) {
            return previousValue + invoiceInfo.discountAmount;
          } else {
            return previousValue + invoiceInfo.openAmount;
          }
        },
      ).toPrecision(2);

  bool get hasFilters =>
      areDatesEqual(
        rxInvoiceFromDate.value,
        rxEarliestInvoiceDate.value,
      ) &&
      areDatesEqual(rxInvoiceToDate.value, DateTime.now()) &&
      rxInvoiceNumberInput.value.isEmpty;

  void clearOpenFilters() {
    rxInvoiceFromDate.value = rxEarliestInvoiceDate.value;

    rxInvoiceToDate.value = DateTime.now();

    rxInvoiceNumberInput.value = '';

    invoiceNumberTextEditingController.clear();
    invoicesOlderThanTextEditingController.clear();
  }

  void clearPaidFilters() {
    rxReceiptFromDate.value = rxEarliestReceiptDate.value;

    rxReceiptToDate.value = DateTime.now();

    rxInvoiceNumberInput.value = '';

    invoiceNumberTextEditingController.clear();
  }

  List<InvoiceInfo> get paidInvoices => _rxInvoiceInfos
      .where((invoiceInfo) => invoiceInfo.status == InvoiceStatus.paid)
      .toList()
    ..sort(
      (a, b) => b.receiptDate.compareTo(a.receiptDate) == 0
          ? a.invoiceNumber.compareTo(b.invoiceNumber)
          : b.receiptDate.compareTo(a.receiptDate),
    );

  List<InvoiceInfo> get filteredPaidInvoices {
    List<InvoiceInfo> filteredInvoices = paidInvoices
        .where(
          (invoiceInfo) =>
              invoiceInfo.invoiceNumber
                  .toString()
                  .contains(rxInvoiceNumberInput.value) &&
              invoiceInfo.receiptDate.isAfter(
                rxReceiptFromDate.value.subtract(
                  const Duration(days: 1),
                ),
              ) &&
              invoiceInfo.receiptDate.isBefore(
                rxReceiptToDate.value.add(
                  const Duration(days: 1),
                ),
              ),
        )
        .toList();

    return filteredInvoices;
  }

  List<InvoiceInfo> get filteredOpenInvoices => openInvoices
      .where(
        (invoiceInfo) =>
            invoiceInfo.invoiceNumber
                .toString()
                .contains(rxInvoiceNumberInput.value) &&
            invoiceInfo.date.isAfter(
              rxInvoiceFromDate.value.subtract(
                const Duration(days: 1),
              ),
            ) &&
            invoiceInfo.date.isBefore(
              rxInvoiceToDate.value.add(
                const Duration(days: 1),
              ),
            ),
      )
      .toList();

  int get daysBetweenNowAndToDate =>
      DateTime.now().difference(rxInvoiceToDate.value).inDays;
}
