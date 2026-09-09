
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
                  } else if (aba['titulo'] == 'Serviço de Campo') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaServicoCampo()),
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
// TELA DE SERVIÇO DE CAMPO (Grade 5x32)
// ==========================================
class TelaServicoCampo extends StatefulWidget {
  const TelaServicoCampo({super.key});

  @override
  State<TelaServicoCampo> createState() => _TelaServicoCampoState();
}

class _TelaServicoCampoState extends State<TelaServicoCampo> {
  final List<String> _cabecalhoServico = [
    'mês',
    'semana',
    'local',
    'horário',
    'dirigente'
  ];

  late List<List<TextEditingController>> _controllersServico;

  @override
  void initState() {
    super.initState();
    // Dias da semana simulados para preenchimento automático de exemplo nas 31 linhas de dados
    final List<String> diasSemanaPadrao = [
      'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom',
      'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom',
      'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom',
      'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom',
      'Seg', 'Ter', 'Qua'
    ];

    _controllersServico = List.generate(
      32,
      (linhaIndex) {
        return List.generate(5, (colunaIndex) {
          String valorInicial = '';
          // Linha 0 em diante representa os dias de 1 a 31
          if (linhaIndex < 31) {
            if (colunaIndex == 0) {
              valorInicial = '${linhaIndex + 1}'; // Dia do mês (1 a 31)
            } else if (colunaIndex == 1) {
              valorInicial = diasSemanaPadrao[linhaIndex]; // Dia da semana
            } else if (colunaIndex == 3) {
              valorInicial = '08:30'; // Horário padrão solicitado
            }
          }
          return TextEditingController(text: valorInicial);
        });
      },
    );
  }

  @override
  void dispose() {
    for (var linha in _controllersServico) {
      for (var c in linha) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _salvarServicoCampo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Serviço de Campo salvo com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Larguras ajustadas: Mês(50), Semana(65), Local(130), Horário(65), Dirigente(180)
    final List<double> largurasColunas = [50, 65, 130, 65, 180];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviço de Campo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Programação do Serviço de Campo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Linha de Cabeçalho
                  Row(
                    children: List.generate(5, (index) {
                      return Container(
                        width: largurasColunas[index],
                        height: 40,
                        margin: const EdgeInsets.only(right: 4, bottom: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _cabecalhoServico[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                  ),
                  // Linhas de dados (32 linhas)
                  ...List.generate(32, (linhaIndex) {
                    return Row(
                      children: List.generate(5, (colunaIndex) {
                        return Container(
                          width: largurasColunas[colunaIndex],
                          height: 38,
                          margin: const EdgeInsets.only(right: 4, bottom: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _controllersServico[linhaIndex][colunaIndex],
                            style: const TextStyle(fontSize: 11),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                              isDense: true,
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _salvarServicoCampo,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Serviço de Campo', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TELA DE LISTA DE TERRITÓRIOS (1 a 14)
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
      'imagemUrl': '',
      'gradeDirigente': List.generate(
        11,
        (linhaIndex) => List.generate(
          9,
          (colunaIndex) => colunaIndex == 0 ? '${linhaIndex + 1}' : '',
        ),
      ),
      'gradeQuadras': List.generate(
        11,
        (linhaIndex) => List.generate(
          15,
          (colunaIndex) => 0,
        ),
      ),
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
        'imagemUrl': '',
        'gradeDirigente': List.generate(
          11,
          (linhaIndex) => List.generate(
            9,
            (colunaIndex) => colunaIndex == 0 ? '${linhaIndex + 1}' : '',
          ),
        ),
        'gradeQuadras': List.generate(
          11,
          (linhaIndex) => List.generate(
            15,
            (colunaIndex) => 0,
          ),
        ),
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
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaDetalheTerritorio(territorio: territorio),
                  ),
                );
                setState(() {});
              },
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

// ==========================================
// PÁGINA DE DETALHES DE CADA TERRITÓRIO
// ==========================================
class TelaDetalheTerritorio extends StatefulWidget {
  final Map<String, dynamic> territorio;

  const TelaDetalheTerritorio({super.key, required this.territorio});

  @override
  State<TelaDetalheTerritorio> createState() => _TelaDetalheTerritorioState();
}

class _TelaDetalheTerritorioState extends State<TelaDetalheTerritorio> {
  late TextEditingController _urlController;
  late TextEditingController _responsavelController;
  late bool _disponivel;
  
  late List<List<TextEditingController>> _controllersDirigente;
  late List<List<int>> _estadosQuadras;

  final List<String> _cabecalhoDirigente = [
    'Nº',
    'DIRIGENTE',
    'PUBLI',
    'DATA',
    'DIRIGENTE',
    'PUBLI',
    'DATA',
    'DATA INICIAL',
    'DATA FINAL'
  ];

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.territorio['imagemUrl']);
    _responsavelController = TextEditingController(text: widget.territorio['responsavel']);
    _disponivel = widget.territorio['disponivel'];

    List<List<String>> dadosDirigente = widget.territorio['gradeDirigente'];
    _controllersDirigente = List.generate(
      11,
      (linhaIndex) => List.generate(
        9,
        (colunaIndex) => TextEditingController(text: dadosDirigente[linhaIndex][colunaIndex]),
      ),
    );

    List<dynamic> dadosQuadrasSalvos = widget.territorio['gradeQuadras'];
    _estadosQuadras = List.generate(
      11,
      (linhaIndex) => List.generate(
        15,
        (colunaIndex) {
          return dadosQuadrasSalvos[linhaIndex][colunaIndex] is int
              ? dadosQuadrasSalvos[linhaIndex][colunaIndex]
              : 0;
        },
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _responsavelController.dispose();
    for (var linha in _controllersDirigente) {
      for (var c in linha) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _salvarAlteracoes() {
    List<List<String>> novosDirigentes = List.generate(
      11,
      (linhaIndex) => List.generate(
        9,
        (colunaIndex) => _controllersDirigente[linhaIndex][colunaIndex].text,
      ),
    );

    setState(() {
      widget.territorio['imagemUrl'] = _urlController.text;
      widget.territorio['responsavel'] = _responsavelController.text;
      widget.territorio['disponivel'] = _disponivel;
      widget.territorio['gradeDirigente'] = novosDirigentes;
      widget.territorio['gradeQuadras'] = _estadosQuadras;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Território salvo com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.territorio['nome']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Visualização do Mapa do Território',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: _urlController.text.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Nenhum mapa inserido', style: TextStyle(color: Colors.grey)),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _urlController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Text('Erro ao carregar imagem', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Link da Imagem do Mapa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Território Disponível?'),
              value: _disponivel,
              onChanged: (bool value) => setState(() => _disponivel = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _responsavelController,
              decoration: const InputDecoration(
                labelText: 'Responsável / Publicador',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 24),

            // GRADE DIRIGENTE (9x11)
            const Text(
              'Grade DIRIGENTE (9x11)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(9, (index) {
                      return Container(
                        width: index == 0 ? 40 : 110,
                        height: 38,
                        margin: const EdgeInsets.only(right: 4, bottom: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade700,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _cabecalhoDirigente[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                  ),
                  ...List.generate(11, (linhaIndex) {
                    return Row(
                      children: List.generate(9, (colunaIndex) {
                        return Container(
                          width: colunaIndex == 0 ? 40 : 110,
                          height: 38,
                          margin: const EdgeInsets.only(right: 4, bottom: 4),
                          decoration: BoxDecoration(
                            color: colunaIndex == 0 ? Colors.grey.shade200 : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _controllersDirigente[linhaIndex][colunaIndex],
                            readOnly: colunaIndex == 0,
                            style: const TextStyle(fontSize: 11),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                              isDense: true,
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // GRADE QUADRAS TRABALHADAS (15x11)
            const Text(
              'Grade QUADRAS TRABALHADAS (15x11) - Toque para colorir',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(11, (linhaIndex) {
                    return Row(
                      children: List.generate(15, (colunaIndex) {
                        if (colunaIndex == 0) {
                          return Container(
                            width: 40,
                            height: 38,
                            margin: const EdgeInsets.only(right: 4, bottom: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${linhaIndex + 1}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          );
                        }

                        if (linhaIndex == 0) {
                          return Container(
                            width: 45,
                            height: 38,
                            margin: const EdgeInsets.only(right: 4, bottom: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              colunaIndex < 10 ? '0$colunaIndex' : '$colunaIndex',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }

                        int estadoCor = _estadosQuadras[linhaIndex][colunaIndex];
                        Color corFundo = Colors.white;
                        if (estadoCor == 1) {
                          corFundo = Colors.yellow.shade400;
                        } else if (estadoCor == 2) {
                          corFundo = Colors.green.shade500;
                        }

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _estadosQuadras[linhaIndex][colunaIndex] = (estadoCor + 1) % 3;
                            });
                          },
                          child: Container(
                            width: 45,
                            height: 38,
                            margin: const EdgeInsets.only(right: 4, bottom: 4),
                            decoration: BoxDecoration(
                              color: corFundo,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _salvarAlteracoes,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Território', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
