// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDetailLineImpl _$$OrderDetailLineImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderDetailLineImpl(
      company: json['company'] as String,
      orderNumber: (json['orderNumber'] as num).toInt(),
      orderType: json['orderType'] as String,
      lineNumber: (json['lineNumber'] as num).toDouble(),
      dateShipped: json['dateShipped'] == null
          ? null
          : DateTime.parse(json['dateShipped'] as String),
      dateInvoiced: json['dateInvoiced'] == null
          ? null
          : DateTime.parse(json['dateInvoiced'] as String),
      item: json['item'] as String,
      itemDescription: json['itemDescription'] as String,
      userComment: json['userComment'] as String,
      nextStatus: json['nextStatus'] as String,
      nextStatusDescription: json['nextStatusDescription'] as String,
      lastStatus: json['lastStatus'] as String,
      lastStatusDescription: json['lastStatusDescription'] as String,
      quantityOrdered: (json['quantityOrdered'] as num).toInt(),
      quantityShipped: (json['quantityShipped'] as num).toInt(),
      quantityCancelled: (json['quantityCancelled'] as num).toInt(),
      quantityBackordered: (json['quantityBackordered'] as num).toInt(),
      invoiceNumber: (json['invoiceNumber'] as num).toInt(),
      invoiceType: json['invoiceType'] as String,
      invoiceCompany: json['invoiceCompany'] as String,
      workOrderNumber: (json['workOrderNumber'] as num).toInt(),
      workOrderType: json['workOrderType'] as String,
      woStatus: json['woStatus'] as String,
      orderLineReference: json['orderLineReference'] as String,
      catalogName: json['catalogName'] as String,
      buyerCode: json['buyerCode'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      extendedPrice: (json['extendedPrice'] as num).toDouble(),
      lightSource1: json['lightSource1'] as String,
      shipToAttention: json['shipToAttention'] as String,
    );

Map<String, dynamic> _$$OrderDetailLineImplToJson(
        _$OrderDetailLineImpl instance) =>
    <String, dynamic>{
      'company': instance.company,
      'orderNumber': instance.orderNumber,
      'orderType': instance.orderType,
      'lineNumber': instance.lineNumber,
      'dateShipped': instance.dateShipped?.toIso8601String(),
      'dateInvoiced': instance.dateInvoiced?.toIso8601String(),
      'item': instance.item,
      'itemDescription': instance.itemDescription,
      'userComment': instance.userComment,
      'nextStatus': instance.nextStatus,
      'nextStatusDescription': instance.nextStatusDescription,
      'lastStatus': instance.lastStatus,
      'lastStatusDescription': instance.lastStatusDescription,
      'quantityOrdered': instance.quantityOrdered,
      'quantityShipped': instance.quantityShipped,
      'quantityCancelled': instance.quantityCancelled,
      'quantityBackordered': instance.quantityBackordered,
      'invoiceNumber': instance.invoiceNumber,
      'invoiceType': instance.invoiceType,
      'invoiceCompany': instance.invoiceCompany,
      'workOrderNumber': instance.workOrderNumber,
      'workOrderType': instance.workOrderType,
      'woStatus': instance.woStatus,
      'orderLineReference': instance.orderLineReference,
      'catalogName': instance.catalogName,
      'buyerCode': instance.buyerCode,
      'unitPrice': instance.unitPrice,
      'extendedPrice': instance.extendedPrice,
      'lightSource1': instance.lightSource1,
      'shipToAttention': instance.shipToAttention,
    };
