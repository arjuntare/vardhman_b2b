class DtmEntryLine {
  final String shade;
  final String buyerCode;
  final String firstLightSource;
  final String secondLightSource;
  final String substrate;
  final String tex;
  final String ticket;
  final String brand;
  final String article;
  final String requestType;
  final String colorName;
  final String lab;
  final String comment;
  final String billingType;
  final String uom;
  final String endUse;
  final int quantity;

  DtmEntryLine({
    required this.endUse,
    required this.uom,
    required this.requestType,
    required this.lab,
    required this.billingType,
    required this.buyerCode,
    required this.firstLightSource,
    required this.secondLightSource,
    required this.colorName,
    required this.shade,
    required this.substrate,
    required this.tex,
    required this.brand,
    required this.article,
    required this.ticket,
    required this.comment,
    required this.quantity,
  });

  String get colorRemark => [
        if (colorName.isNotEmpty) colorName,
        if (comment.isNotEmpty) comment,
        if (lab.isNotEmpty) lab,
        if (requestType.isNotEmpty) requestType,
        if (endUse.isNotEmpty) endUse,
      ].join('|');
}
