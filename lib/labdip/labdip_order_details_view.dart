import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:vardhman_b2b/api/api.dart';
import 'package:vardhman_b2b/catalog/catalog_controller.dart';
import 'package:vardhman_b2b/common/header_view.dart';
import 'package:vardhman_b2b/common/primary_button.dart';
import 'package:vardhman_b2b/common/secondary_button.dart';
import 'package:vardhman_b2b/constants.dart';
import 'package:vardhman_b2b/labdip/labdip_controller.dart';
import 'package:vardhman_b2b/user/user_controller.dart';

class LabdipOrderDetailsView extends StatelessWidget {
  const LabdipOrderDetailsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final LabdipController labdipController = Get.find<LabdipController>();

    final CatalogController catalogController = Get.find<CatalogController>();

    return Obx(
      () {
        final hasDispatchedLine = labdipController.rxOrderDetailLines.any(
          (element) => element.status == 'Dispatched',
        );

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              HeaderView(
                elevation: 4,
                title: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: VardhmanColors.darkGrey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (labdipController.rxSelectedOrderHeaderLine.value !=
                            null) ...[
                          Text(
                            'Order Details for ${labdipController.rxSelectedOrderHeaderLine.value!.orderReference}',
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'JDE order no. ${labdipController.rxSelectedOrderHeaderLine.value!.orderNumber}',
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Dated ${DateFormat('dd/MM/yyyy').format(labdipController.rxSelectedOrderHeaderLine.value!.orderDate)}',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: labdipController.rxSelectedOrderHeaderLine.value == null
                    ? const Center(
                        child: Text('No Order Selected'),
                      )
                    : DataTable2(
                        columnSpacing: 8,
                        showBottomBorder: true,
                        border: TableBorder.symmetric(
                          inside: BorderSide(
                              color: VardhmanColors.darkGrey, width: 0.2),
                          outside: BorderSide(
                              color: VardhmanColors.darkGrey, width: 0.2),
                        ),
                        headingCheckboxTheme: CheckboxThemeData(
                          fillColor: WidgetStatePropertyAll(Colors.white),
                          checkColor:
                              WidgetStatePropertyAll(VardhmanColors.red),
                        ),
                        datarowCheckboxTheme: CheckboxThemeData(
                          fillColor: WidgetStatePropertyAll(Colors.white),
                          checkColor:
                              WidgetStatePropertyAll(VardhmanColors.red),
                        ),
                        dataTextStyle: TextStyle(
                          color: VardhmanColors.darkGrey,
                          fontSize: 13,
                        ),
                        checkboxHorizontalMargin: 0,
                        horizontalMargin: 0,
                        showCheckboxColumn: false,
                        headingRowHeight: 40,
                        dataRowHeight: 40,
                        headingRowColor:
                            WidgetStatePropertyAll(VardhmanColors.darkGrey),
                        headingTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        columns: [
                          DataColumn2(
                            label: Text('#'),
                            size: ColumnSize.S,
                            fixedWidth: 30,
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Article'),
                            fixedWidth: 60,
                          ),
                          DataColumn2(label: Text('Brand'), size: ColumnSize.M),
                          DataColumn2(
                            label: Text('Ticket'),
                            fixedWidth: 50,
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text('Tex'),
                            numeric: true,
                            fixedWidth: 40,
                          ),
                          DataColumn2(
                            label: Text('Shade'),
                            fixedWidth: 60,
                          ),
                          DataColumn2(
                            label: Text('Final Shade'),
                            fixedWidth: 80,
                          ),
                          DataColumn2(
                              label: Text('Remark'), size: ColumnSize.S),
                          DataColumn2(
                              label: Text('Status'), size: ColumnSize.M),
                          if (hasDispatchedLine)
                            DataColumn2(
                                label: Text('Feedback'), size: ColumnSize.L),
                        ],
                        rows: labdipController.rxOrderDetailLines.map(
                          (orderDetail) {
                            final itemParts =
                                orderDetail.item.split(RegExp('\\s+'));

                            final String article = itemParts[0];
                            final String uom = itemParts[1];
                            final String shade = itemParts[2];

                            final catalogItem = catalogController
                                .rxFilteredItems
                                .firstWhereOrNull(
                              (itemCatalogInfo) =>
                                  itemCatalogInfo.article == article &&
                                  itemCatalogInfo.uom == uom,
                            );

                            final labdipTableRow = labdipController
                                .getLabdipTableRow(orderDetail.workOrderNumber);

                            final index = labdipController.rxOrderDetailLines
                                .indexOf(orderDetail);

                            final reason = labdipController
                                    .rxSelectedOrderDetailLinesReasonMap[
                                orderDetail];

                            final isDispatchedLine =
                                orderDetail.status == 'Dispatched';

                            final noneBorder = OutlineInputBorder(
                              borderSide: BorderSide.none,
                            );

                            return DataRow(
                              color: WidgetStatePropertyAll(
                                index.isEven
                                    ? Colors.white
                                    : VardhmanColors.dividerGrey,
                              ),
                              cells: [
                                DataCell(
                                  Text(orderDetail.lineNumber.toString()),
                                ),
                                DataCell(
                                  Text(article),
                                ),
                                DataCell(
                                  Text(catalogItem?.brandDesc ?? ''),
                                ),
                                DataCell(
                                  Text(catalogItem?.ticket ?? ''),
                                ),
                                DataCell(
                                  Text(catalogItem?.tex ?? ''),
                                ),
                                DataCell(
                                  Text(shade),
                                ),
                                DataCell(
                                  Text(labdipTableRow?.permanentShade == null
                                      ? ''
                                      : '${labdipTableRow?.permanentShade} ${labdipTableRow?.reference}'),
                                ),
                                DataCell(
                                  Text(orderDetail.userComment),
                                ),
                                DataCell(
                                  Text(orderDetail.status),
                                ),
                                if (hasDispatchedLine)
                                  DataCell(
                                    !isDispatchedLine
                                        ? SizedBox()
                                        : Container(
                                            height: 36,
                                            margin: const EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: VardhmanColors.darkGrey,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: DropdownSearch<String>(
                                                    enabled: true,
                                                    decoratorProps:
                                                        DropDownDecoratorProps(
                                                      baseStyle: TextStyle(
                                                        color:
                                                            VardhmanColors.red,
                                                        fontSize: 13,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'select',
                                                        hintStyle: TextStyle(
                                                          color: VardhmanColors
                                                              .darkGrey,
                                                          fontSize: 13,
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 8),
                                                        border: noneBorder,
                                                        enabledBorder:
                                                            noneBorder,
                                                        focusedBorder:
                                                            noneBorder,
                                                        disabledBorder:
                                                            noneBorder,
                                                      ),
                                                    ),
                                                    popupProps: PopupProps.menu(
                                                      searchFieldProps:
                                                          TextFieldProps(
                                                        autocorrect: false,
                                                        style: TextStyle(
                                                          color: VardhmanColors
                                                              .darkGrey,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      showSearchBox: true,
                                                      fit: FlexFit.loose,
                                                      searchDelay: Duration(
                                                          milliseconds: 0),
                                                      itemBuilder: (context,
                                                              item,
                                                              isDisabled,
                                                              isSelected) =>
                                                          ListTile(
                                                        title: Text(
                                                          item,
                                                          style: TextStyle(
                                                            color:
                                                                VardhmanColors
                                                                    .darkGrey,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    items:
                                                        (searchText, cs) async {
                                                      final trimmedSearchText =
                                                          searchText.trim();

                                                      return [
                                                        if (trimmedSearchText
                                                                .isNotEmpty &&
                                                            !labdipController
                                                                .rejectionReasons
                                                                .contains(
                                                                    trimmedSearchText))
                                                          trimmedSearchText,
                                                        ...labdipController
                                                            .rejectionReasons
                                                      ];
                                                    },
                                                    autoValidateMode:
                                                        AutovalidateMode
                                                            .disabled,
                                                    onChanged: (newValue) {
                                                      labdipController
                                                                  .rxSelectedOrderDetailLinesReasonMap[
                                                              orderDetail] =
                                                          newValue ?? '';
                                                    },
                                                    selectedItem: reason,
                                                  ),
                                                ),
                                                if (reason != null &&
                                                    reason.isNotEmpty)
                                                  SecondaryButton(
                                                    wait: false,
                                                    iconData: Icons.clear,
                                                    text: '',
                                                    onPressed: () async {
                                                      labdipController
                                                          .rxSelectedOrderDetailLinesReasonMap
                                                          .remove(orderDetail);
                                                    },
                                                  ),
                                              ],
                                            ),
                                          ),
                                  ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
              ),
              if (labdipController
                  .rxSelectedOrderDetailLinesReasonMap.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: VardhmanColors.darkGrey,
                        width: 0.2,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '${labdipController.rxSelectedOrderDetailLinesReasonMap.length} line${labdipController.rxSelectedOrderDetailLinesReasonMap.length > 1 ? 's' : ''} selected'),
                      PrimaryButton(
                        text: 'Rematch',
                        onPressed: () async {
                          final UserController userController =
                              Get.find<UserController>(tag: 'userController');

                          final nextOrderNumber = await Api.fetchOrderNumber();

                          final b2bOrderNumber = 'B2BL-$nextOrderNumber';

                          if (nextOrderNumber != null) {
                            final isSubmitted = await Api.submitRematchOrder(
                              merchandiserName: '',
                              b2bOrderNumber: b2bOrderNumber,
                              branchPlant: userController.branchPlant,
                              soldTo: userController
                                  .rxCustomerDetail.value.soldToNumber,
                              shipTo: (userController.rxDeliveryAddress.value
                                              ?.deliveryAddressNumber ==
                                          0
                                      ? userController
                                          .rxCustomerDetail.value.soldToNumber
                                      : userController.rxDeliveryAddress.value
                                          ?.deliveryAddressNumber)
                                  .toString(),
                              company: userController
                                  .rxCustomerDetail.value.companyCode,
                              orderTakenBy:
                                  userController.rxUserDetail.value.role,
                              orderDetailLines: labdipController
                                  .rxSelectedOrderDetailLinesReasonMap.keys
                                  .toList(),
                              selectedOrderDetailLinesReasonMap:
                                  labdipController
                                      .rxSelectedOrderDetailLinesReasonMap,
                            );

                            if (isSubmitted) {
                              labdipController
                                  .rxSelectedOrderDetailLinesReasonMap
                                  .clear();

                              toastification.show(
                                autoCloseDuration: Duration(seconds: 5),
                                primaryColor: VardhmanColors.green,
                                title: Text(
                                  'Order $b2bOrderNumber placed successfully!',
                                ),
                              );

                              if (userController
                                  .rxCustomerDetail.value.canSendSMS) {
                                Api.sendOrderEntrySMS(
                                  orderNumber: b2bOrderNumber,
                                  mobileNumber: userController
                                      .rxCustomerDetail.value.mobileNumber,
                                );
                              }

                              if (userController
                                  .rxCustomerDetail.value.canSendWhatsApp) {
                                Api.sendOrderEntryWhatsApp(
                                  orderNumber: b2bOrderNumber,
                                  mobileNumber: userController
                                      .rxCustomerDetail.value.mobileNumber,
                                );
                              }
                            } else {
                              toastification.show(
                                autoCloseDuration: Duration(seconds: 5),
                                primaryColor: VardhmanColors.red,
                                title: Text(
                                  'Some error placing the order!',
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
