import 'package:flutter/material.dart';

class LabdipOrdersView extends StatelessWidget {
  final List<Map<String, String>> labdipOrders;

  const LabdipOrdersView({
    super.key,
    required this.labdipOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'LABDIP ORDERS',
            textAlign: TextAlign.center,
          ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: labdipOrders.first.keys
                      .map(
                        (e) => DataColumn(
                          label: Text(e),
                        ),
                      )
                      .toList(),
                  rows: labdipOrders
                      .map(
                        (labdipOrderMap) => DataRow(
                          cells: labdipOrderMap.values
                              .map(
                                (labdipOrderData) => DataCell(
                                  Text(labdipOrderData),
                                ),
                              )
                              .toList(),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
