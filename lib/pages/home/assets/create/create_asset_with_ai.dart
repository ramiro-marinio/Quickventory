import 'package:flutter/material.dart';
import 'package:inventory/functions/push.dart';
import 'package:inventory/models/asset.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/pages/home/assets/create/create_asset_full.dart';
import 'package:inventory/pages/home/assets/create/create_asset_simple.dart';
import 'package:inventory/providers/claude_provider.dart';
import 'package:inventory/providers/db_provider.dart';
import 'package:inventory/providers/shared_preferences_provider.dart';
import 'package:inventory/widgets/asset_widget.dart';
import 'package:provider/provider.dart';

class CreateAssetWithAi extends StatefulWidget {
  const CreateAssetWithAi({super.key});

  @override
  State<CreateAssetWithAi> createState() => _CreateAssetWithAiState();
}

class _CreateAssetWithAiState extends State<CreateAssetWithAi> {
  String text = '';
  final TextEditingController textEditingController = TextEditingController();
  Asset? result;
  @override
  void initState() {
    super.initState();
    textEditingController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    final DbProvider dbProvider = context.watch<DbProvider>();
    final SharedPreferencesProvider sharedPreferencesProvider =
        context.read<SharedPreferencesProvider>();
    Currency mainCurrency = sharedPreferencesProvider.getMainCurrency(context);
    final claudeProvider = context.read<ClaudeProvider>();
    return SizedBox(
      width: double.infinity,
      child: AlertDialog(
        title: Text(result == null
            ? 'Create Asset with AI'
            : 'Is this result correct?'),
        content: Builder(
          builder: (context) {
            if (result == null) {
              return SizedBox(
                width: 400,
                child: TextField(
                  onChanged: (value) => text = value,
                  decoration: commonDecoration,
                  controller: textEditingController,
                  maxLines: 7,
                ),
              );
            } else {
              return AssetWidget(asset: result!);
            }
          },
        ),
        actions: [
          if (result == null) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final assetJson = await claudeProvider.createAssetWithAI(
                  textEditingController.text,
                  mainCurrency,
                  dbProvider.currencies,
                );
                if (context.mounted) {
                  result = Asset.fromJson(assetJson, context);
                  setState(() {});
                }
              },
              child: const Text('Generate'),
            ),
          ] else ...[
            TextButton(
              onPressed: () {
                setState(() {
                  result = null;
                });
              },
              child: const Text('Redo Query'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                push(
                  context,
                  CreateAssetFull(
                    asset: result,
                  ),
                );
              },
              child: const Text('Edit Asset'),
            ),
            TextButton(
              onPressed: () {
                dbProvider.createAsset(result!, context);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            )
          ]
        ],
      ),
    );
  }
}
