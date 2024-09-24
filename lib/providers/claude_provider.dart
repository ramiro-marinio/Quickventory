import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/models/asset.dart';
import 'package:inventory/models/currency.dart';
import 'package:inventory/models/person.dart';

class ClaudeProvider extends ChangeNotifier {
  final apiKey =
      "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";
  Future<Map<String, dynamic>> createAssetWithAI(
      String prompt, Currency mainCurrency, List<Currency> currencies) async {
    final client = AnthropicClient(apiKey: apiKey);
    final createAssetTool = Tool(name: 'create_asset', inputSchema: {
      'type': 'object',
      'description':
          'Based on data the user gives you, create the asset they have or have obtained.',
      'properties': {
        'currency': {
          'type': 'number',
          'description':
              'The ID of the currency used to calculate the asset`s worth. Chosen by the user. If not chosen, use default currency (will be provided).',
        },
        'moneyValue': {
          'type': 'number',
          'description': 'The amount of currency the asset is worth',
        },
        'assetName': {
          'type': 'string',
          'description': 'A name for the asset.',
        },
        'assetCategory': {
          'type': 'string',
          'description': 'the category the asset fits into.',
          'enum': AssetCategory.values.map((asset) => asset.id).toList(),
        },
        'assetDescription': {
          'type': 'string',
          'description': 'A short description for the asset.',
        },
        'createdAt': {
          'type': 'string',
          'description':
              'Creation time of the asset. expresed in dd/MM/YYYY. CAN BE NULL.',
        },
        'expiresAt': {
          'type': 'string',
          'description':
              'When the asset is no longer worth something or expires. expresed in dd/MM/YYYY. CAN BE NULL.',
        },
      },
      "required": [
        "assetDescription,assetName,moneyValue,currency,assetCategory"
      ]
    });
    final request1 = CreateMessageRequest(
      model: const Model.model(Models.claude35Sonnet20240620),
      messages: [
        Message(
          role: MessageRole.user,
          content: MessageContent.text(
            """Based on the user`s prompt and the data we`ll give you, define the asset.
              If the user omits the currency in which the price is calculated, use use dollars (ID: 1).
              In moneyValue, put THE AMOUNT OF CURRENCY. For example, if you believe the appropriate currency is Euro, and something costs 3 euros, moneyValue is 3.
              If the user doesn't define the value of the asset, approximate it yourself. If you do not know the value, try to think about the power of negotiation
              the asset could give the user or how much someone would pay for it. TRY NOT TO LEAVE IT AT 0. DO NOT LEAVE BLANK OR AS UNKNOWN.
              In case you need to calculate with time, today is ${DateFormat('dd/MM/yyyy').format(DateTime.now())}.
              USER PROMPT: 
              $prompt; 
              CURRENCIES: ${currencies.map((currency) => currency.toJson()).toList().join(',')}""",
          ),
        ),
      ],
      tools: [createAssetTool],
      toolChoice: ToolChoice(
        type: ToolChoiceType.tool,
        name: createAssetTool.name,
      ),
      maxTokens: 1024,
    );
    final aiMessage1 = await client.createMessage(request: request1);
    return aiMessage1.content.toJson()['value'][0]['input'];
  }

  Future<Map<String, dynamic>> createDebtWithAI(
      String prompt,
      Currency mainCurrency,
      List<Currency> currencies,
      List<Person> people) async {
    final client = AnthropicClient(apiKey: apiKey);
    const createDebtTool = Tool(name: 'create_asset', inputSchema: {
      'type': 'object',
      'description':
          'Based on data the user gives you, create the asset they have or have obtained.',
      'properties': {
        'currency': {
          'type': 'number',
          'description':
              'The ID of the currency used to calculate the asset`s worth. Chosen by the user. If not chosen, use default currency (will be provided).',
        },
        'moneyValue': {
          'type': 'number',
          'description': 'The amount of currency the asset is worth',
        },
        'debtName': {
          'type': 'string',
          'description': 'A name for the debt.',
        },
        'debtDescription': {
          'type': 'string',
          'description': 'A short description for the debt.',
        },
        'createdAt': {
          'type': 'string',
          'description':
              'Creation time of the debt. expresed in dd/MM/YYYY. can be not completed.',
        },
        'expiresAt': {
          'type': 'string',
          'description':
              'The time limit to pay the debt or when it is no longer valid. expresed in dd/MM/YYYY. can be not completed.',
        },
        "creditorId": {
          "type": "string",
          'description':
              'ID of the person we owe. If it can not be found, write "NONE"',
        },
        "payableIn": {
          "type": "string",
          "description":
              "the IDs of the currencies in which the debt can be paid. Each currency is separated by a hyphen ('-') If it can be paid in any currency, do not complete."
        }
      },
      "required": ["debtDescription,debtName,moneyValue,currency"]
    });
    final request1 = CreateMessageRequest(
      model: const Model.model(Models.claude35Sonnet20240620),
      messages: [
        Message(
          role: MessageRole.user,
          content: MessageContent.text(
            """Based on the user`s prompt and the data we`ll give you, define the debt.
              If the user omits the currency in which the price is calculated, use dollars (ID: 1).
              In moneyValue, put THE AMOUNT OF CURRENCY. For example, if you believe the appropriate currency is Euro, and something costs 3 euros, moneyValue is 3.
              If the user doesn't define the value of the debt, approximate it yourself. If you do not know how to calculate it, think about the power that the creditor
              would have for negotiation or how much he'd ask for depending on the context. TRY NOT TO LEAVE AS 0. DO NOT LEAVE AS UNKNOWN.
              In case you need to calculate with time, today is ${DateFormat('dd/MM/yyyy').format(DateTime.now())}.
              As to payableIn, always try NOT to complete that unless the user specifies that the debt can only be paid in specific currencies.
              USER PROMPT: 
              $prompt;
              CONTACTS: ${people.map((person) => {
                  "personId": person.id,
                  "name": person.fullName,
                  "phoneNumber": person.phone ?? 'No phone data.',
                  "email": person.email ?? 'No email data.',
                  "address": person.address ?? 'No address data.',
                })} 
              CURRENCIES: ${currencies.map((currency) => currency.toJson()).toList().join(',')}""",
          ),
        ),
      ],
      tools: [createDebtTool],
      toolChoice: ToolChoice(
        type: ToolChoiceType.tool,
        name: createDebtTool.name,
      ),
      maxTokens: 1024,
    );
    final aiMessage1 = await client.createMessage(request: request1);
    return aiMessage1.content.toJson()['value'][0]['input'];
  }
}
