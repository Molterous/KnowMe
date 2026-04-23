import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ds_core/ds_core.dart';
import '../bloc/portfolio_bloc.dart';
import '../widgets/home_shimmer.dart';
import '../widgets/home_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) => switch (state.status) {
          PortfolioStatus.initial ||
          PortfolioStatus.loading =>
            const HomeShimmer(),
          PortfolioStatus.success => HomeContent(data: state.data!),
          PortfolioStatus.failure => _ErrorView(
              message: state.error?.message ?? 'Something went wrong.',
            ),
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Failed to load portfolio', style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          DsButton(
            label: 'Retry',
            onTap: () => context
                .read<PortfolioBloc>()
                .add(const PortfolioDataRequested()),
          ),
        ],
      ),
    );
  }
}
