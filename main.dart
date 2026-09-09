import 'package:flutter/material.dart';

void main() {
  runApp(const MapaDeTerritorioApp());
}

class MapaDeTerritorioApp extends StatelessWidget {
  const MapaDeTerritorioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa de Território',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PaginaInicial(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> botoesAbas = [
      {'titulo': 'Território', 'icone': Icons.map, 'cor': Colors.blue},
      {'titulo': 'Serviço de Campo', 'icone': Icons.group, 'cor': Colors.green},
      {'titulo': 'Dirigente', 'icone': Icons.person, 'cor': Colors.orange},
      {'titulo': 'S.13', 'icone': Icons.assignment, 'cor': Colors.purple},
      {'titulo': 'Eventos', 'icone': Icons.event, 'cor': Colors.red},
      {'titulo': 'Admin', 'icone': Icons.admin_panel_settings, 'cor': Colors.teal},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Território'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: botoesAbas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final aba = botoesAbas[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  if (aba['titulo'] == 'Território') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaTerritorio()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Abrindo: ${aba['titulo']}')),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      aba['icone'],
                      size: 48,
                      color: aba['cor'],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      aba['titulo'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// TELA DE TERRITÓRIOS (Integrada no mesmo arquivo)
// ==========================================
class TelaTerritorio extends StatefulWidget {
  const TelaTerritorio({super.key});

  @override
  State<TelaTerritorio> createState() => _TelaTerritorioState();
}

class _TelaTerritorioState extends State<TelaTerritorio> {
  final List<Map<String, dynamic>> _territorios = List.generate(
    14,
    (index) => {
      'numero': index + 1,
      'nome': 'Território ${index + 1}',
      'disponivel': true,
      'responsavel': 'Nenhum',
    },
  );

  void _adicionarTerritorio() {
    setState(() {
      int novoNumero = _territorios.length + 1;
      _territorios.add({
        'numero': novoNumero,
        'nome': 'Território $novoNumero',
        'disponivel': true,
        'responsavel': 'Nenhum',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Territórios'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _territorios.length,
        itemBuilder: (context, index) {
          final territorio = _territorios[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: territorio['disponivel'] ? Colors.green : Colors.orange,
                child: Text(
                  '${territorio['numero']}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                territorio['nome'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                territorio['disponivel']
                    ? 'Status: Disponível'
                    : 'Designado para: ${territorio['responsavel']}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Abrindo ${territorio['nome']}')),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarTerritorio,
        tooltip: 'Adicionar Território',
        child: const Icon(Icons.add),
      ),
    );
  }
}
