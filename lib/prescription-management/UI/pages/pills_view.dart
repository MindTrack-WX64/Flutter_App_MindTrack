import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/prescription-management/model/prescription.dart';
import 'package:mind_track_flutter_app/prescription-management/service/prescription_service.dart';

class PillsView extends StatefulWidget {
  final List<Pill> pills; // Recibe el array de pills
  final String token; // Recibe el token
  final int prescriptionId; // Recibe el id de la prescripción

  PillsView({required this.pills, required this.token, required this.prescriptionId});

  @override
  _PillsViewState createState() => _PillsViewState();
}

class _PillsViewState extends State<PillsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pills List'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.pills.isEmpty
            ? Center(
          child: Text(
            'No pills available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: widget.pills.length,
          itemBuilder: (context, index) {
            final pill = widget.pills[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pill.name ?? 'No Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Description: ${pill.description ?? 'No description available'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Quantity: ${pill.quantity ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Frequency: ${pill.frequency ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPillsDialog(),
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _showPillsDialog() {
    final _pillNameController = TextEditingController();
    final _pillDescriptionController = TextEditingController();
    final _pillQuantityController = TextEditingController();
    final _pillFrecuencyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Pill'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _pillNameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _pillDescriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _pillQuantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _pillFrecuencyController,
                decoration: InputDecoration(labelText: 'Frequency'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final pill = Pill(
                    name: _pillNameController.text,
                    description: _pillDescriptionController.text,
                    quantity: int.tryParse(_pillQuantityController.text) ?? 0,
                    frequency: _pillFrecuencyController.text,
                );
                _addPillsToPrescription(pill);
                Navigator.pop(context); // Close the dialog after saving
              },
                child: Text('Save', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                )
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without saving
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addPillsToPrescription(Pill pill) async {
    try {
      // Llamamos al servicio para guardar la pastilla en el backend
      final prescriptionService = PrescriptionService();
      await prescriptionService.addPill(widget.prescriptionId, pill, widget.token);

      // Si la llamada al servicio fue exitosa, agregamos la pastilla a la lista local
      setState(() {
        widget.pills.add(pill);
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pill added successfully')),
      );
    } catch (e) {
      // Si hubo algún error al guardar, mostramos un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add pill')),
      );
    }
  }

}
