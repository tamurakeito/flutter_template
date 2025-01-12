import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/view/ui/atoms/app_text.dart';
import 'package:flutter_template/view/ui/molecules/loading_circle_mini.dart';
import 'package:flutter_template/view_model/http_view_model.dart';
import 'package:flutter_template/view_model/local_data_view_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final httpViewModel = ref.read(httpViewModelProvider.notifier);
    final localDataViewModel = ref.read(localDataViewModelProvider.notifier);
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: const AppText(
                "Hello, World!",
                style: AppTextStyle.h1,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: const AppText(
                "http",
                style: AppTextStyle.h2,
              ),
            ),
            HttpButton(
              viewModel: httpViewModel,
              id: 1,
            ),
            HttpButton(
              viewModel: httpViewModel,
              id: 2,
            ),
            HttpButton(
              viewModel: httpViewModel,
              id: 3,
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: const AppText(
                "local data",
                style: AppTextStyle.h2,
              ),
            ),
            LocalDataButton(
              viewModel: localDataViewModel,
              id: 1,
            ),
            LocalDataButton(
              viewModel: localDataViewModel,
              id: 2,
            ),
            LocalDataButton(
              viewModel: localDataViewModel,
              id: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class HttpButton extends HookWidget {
  final HttpViewModel viewModel;
  final int id;
  const HttpButton({
    super.key,
    required this.viewModel,
    required this.id,
  });

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

    return DataButton(
      label: "tap! :$id",
      color: Colors.orange,
      handlePress: handlePress,
      isLoading: isLoading,
    );
  }
}

class LocalDataButton extends HookWidget {
  final LocalDataViewModel viewModel;
  final int id;
  const LocalDataButton({
    super.key,
    required this.viewModel,
    required this.id,
  });

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

    return DataButton(
      label: "tap! :$id",
      color: Colors.indigo,
      handlePress: handlePress,
      isLoading: isLoading,
    );
  }
}

class DataButton extends StatelessWidget {
  final String label;
  final MaterialColor color;
  final void Function()? handlePress;
  final ValueNotifier<bool> isLoading;
  const DataButton({
    super.key,
    required this.label,
    required this.color,
    required this.handlePress,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: handlePress,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            }
            return color.shade100;
          },
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return color.withOpacity(0.3);
            }
            return null;
          },
        ),
      ),
      child: isLoading.value
          ? const LoadingCircleMini()
          : Text(
              label,
              style: TextStyle(
                color: color.shade900,
              ),
            ),
    );
  }
}
