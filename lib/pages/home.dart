import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Test {
  final String id;
  final String nombre;
  final String edad;
  final String telefono;

  Test({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.telefono,
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference testCollection =
      FirebaseFirestore.instance.collection("tb_test");

  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  Future<void> addTest() async {
    String id = idController.text.trim();
    String nombre = nombreController.text.trim();
    String edad = edadController.text.trim();
    String telefono = telefonoController.text.trim();

    if (id.isNotEmpty &&
        nombre.isNotEmpty &&
        edad.isNotEmpty &&
        telefono.isNotEmpty) {
      await testCollection.doc(id).set({
        'nombre': nombre,
        'edad': edad,
        'telefono': telefono,
      });

      // Limpiar los controladores después de agregar un test
      idController.clear();
      nombreController.clear();
      edadController.clear();
      telefonoController.clear();

      _showSnackbar('Guardado');
    } else {
      _showSnackbar('Por favor, completa todos los campos');
    }
  }

  Future<List<Test>> getTests() async {
    QuerySnapshot tests = await testCollection.get();
    List<Test> listaTests = [];
    if (tests.docs.length != 0) {
      for (var doc in tests.docs) {
        final data = doc.data() as Map<String, dynamic>;
        listaTests.add(Test(
          id: doc.id,
          nombre: data['nombre'] ?? '',
          edad: data['edad'] ?? '',
          telefono: data['telefono'] ?? '',
        ));
      }
    }
    return listaTests;
  }

  Future<void> reloadTests() async {
    setState(() {});
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRoundedTextField(
              controller: idController,
              labelText: 'Ingrese su ID',
              icon: Icons.perm_identity,
            ),
            SizedBox(height: 4.0),
            _buildRoundedTextField(
              controller: nombreController,
              labelText: 'Ingrese su Nombre',
              icon: Icons.person,
            ),
            SizedBox(height: 4.0),
            _buildRoundedTextField(
              controller: edadController,
              labelText: 'Ingrese su Edad',
              icon: Icons.format_list_numbered,
            ),
            SizedBox(height: 4.0),
            _buildRoundedTextField(
              controller: telefonoController,
              labelText: 'Ingrese su numero de telefono',
              icon: Icons.phone_android,
            ),
            SizedBox(height: 6.0),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: addTest,
                  icon: Icon(Icons.add),
                  label: Text('AGREGAR'),
                ),
                SizedBox(width: 4.0),
                ElevatedButton.icon(
                  onPressed: reloadTests,
                  icon: Icon(Icons.refresh),
                  label: Text('ACTUALIZAR'),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Lista de Registros:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.0),
            Expanded(
              child: FutureBuilder<List<Test>>(
                future: getTests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('ERROR'),
                    );
                  } else {
                    List<Test>? tests = snapshot.data;
                    return ListView.builder(
                      itemCount: tests!.length,
                      itemBuilder: (context, index) {
                        Test test = tests[index];
                        return ListTile(
                          title: Text('ID: ${test.id}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nombre: ${test.nombre}'),
                              Text('Edad: ${test.edad}'),
                              Text('Teléfono: ${test.telefono}'),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
