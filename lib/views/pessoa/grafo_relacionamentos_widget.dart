import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class GrafoRelacionamentosWidget extends StatelessWidget {
  final String pessoaCentral;
  final List<String> relacionados;

  const GrafoRelacionamentosWidget({
    super.key,
    required this.pessoaCentral,
    required this.relacionados,
  });

  @override
  Widget build(BuildContext context) {
    final Graph graph = Graph();
    final builder = BuchheimWalkerConfiguration();

    // Nó principal
    final centralNode = Node.Id(pessoaCentral);
    graph.addNode(centralNode);

    // Nós relacionados
    for (var nome in relacionados) {
      final node = Node.Id(nome);
      graph.addEdge(centralNode, node);
    }

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: EdgeInsets.all(100),
      minScale: 0.01,
      maxScale: 5,
      child: GraphView(
        graph: graph,
        algorithm: FruchtermanReingoldAlgorithm(iterations: 1000),
        builder: (Node node) => _buildNode(node.key!.value),
      ),
    );
  }

  Widget _buildNode(String nome) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.indigo[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Text(
        nome,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
