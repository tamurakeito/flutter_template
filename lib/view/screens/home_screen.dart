import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/view/ui/molecules/loading_circle_mini.dart';
import 'package:flutter_template/view_model/data_view_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(dataViewModelProvider.notifier);
    return Center(
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            const Text("Hello, World!"),
            HelloworldButton(viewModel: viewModel, id: 1),
            HelloworldButton(viewModel: viewModel, id: 2),
            HelloworldButton(viewModel: viewModel, id: 3),
          ],
        ),
      ),
    );
  }
}

class HelloworldButton extends HookWidget {
  final DataViewModel viewModel;
  final int id;
  const HelloworldButton(
      {super.key, required this.viewModel, required this.id});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);

    void handlePress() async {
      isLoading.value = true;
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        final result = await viewModel.fetchHelloworldDetail(id);

        if (!context.mounted) return;

        if (result.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${result.error}'),
              duration: const Duration(milliseconds: 250),
            ),
          );
          return;
        }
        if (result.data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: data is null'),
              duration: Duration(milliseconds: 250),
            ),
          );
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.data!.hello.name),
            duration: const Duration(milliseconds: 250),
          ),
        );
      } finally {
        isLoading.value = false;
      }
    }

    return TextButton(
      onPressed: handlePress,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey; // 無効状態の背景色
            }
            return Colors.indigo.shade100; // 通常時の背景色
          },
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.indigo.withOpacity(0.3);
            }
            return null;
          },
        ),
      ),
      child: isLoading.value
          ? const LoadingCircleMini()
          : Text(
              "tap! :$id",
              style: TextStyle(
                color: Colors.indigo.shade900,
              ),
            ),
    );
  }
}
