import 'package:chess/ui/pages/game_page/decline_button_widget.dart';
import 'package:flutter/material.dart';

class ConfirmableButton extends StatefulWidget {
  const ConfirmableButton({
    Key? key,
    required this.child,
    this.onConfirm,
    this.onWaitingConfirm,
    this.onDecline,
    this.waitingConfirmation = false,
    this.enabled = true,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onConfirm;
  final VoidCallback? onWaitingConfirm;
  final VoidCallback? onDecline;
  final bool waitingConfirmation;
  final bool enabled;

  @override
  State<ConfirmableButton> createState() => _ConfirmableButtonState();
}

class _ConfirmableButtonState extends State<ConfirmableButton> {
  late bool _waitingConfirmation = widget.waitingConfirmation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            )),
            backgroundColor: MaterialStateProperty.all(
              _waitingConfirmation ? Colors.orange : Colors.grey,
            ),
          ),
          onPressed: widget.enabled
              ? () {
                  if (_waitingConfirmation) {
                    widget.onConfirm?.call();
                  } else {
                    widget.onWaitingConfirm?.call();
                  }
                  setState(() {
                    _waitingConfirmation = !_waitingConfirmation;
                  });
                }
              : null,
          child: widget.child,
        ),
        if (_waitingConfirmation) ...[
          const SizedBox(width: 8),
          DeclineButton(
            onPressed: () {
              widget.onDecline?.call();
              setState(() {
                _waitingConfirmation = false;
              });
            },
          ),
        ],
      ],
    );
  }

  @override
  void didUpdateWidget(ConfirmableButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.waitingConfirmation && widget.waitingConfirmation) {
      _waitingConfirmation = widget.waitingConfirmation;
      widget.onWaitingConfirm?.call();
    }
  }
}
