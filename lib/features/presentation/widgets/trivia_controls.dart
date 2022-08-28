import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({Key? key}) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final TextEditingController _numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _numberController,
          onSubmitted: (_) {
            dispatchConcrete();
          },
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Input a number"),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                  onPressed: dispatchConcrete, child: const Text("Search")),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey.shade200, // Background color
                  ),
                  onPressed: dispatchRandom,
                  child: const Text(
                    "Get Random Trivia",
                    style: TextStyle(color: Colors.black),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(_numberController.text));
    _numberController.clear();
  }

  void dispatchRandom() {
    _numberController.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(const GetTriviaForRandomNumber());
  }
}
