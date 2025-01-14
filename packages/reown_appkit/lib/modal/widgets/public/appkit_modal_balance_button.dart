import 'package:flutter/material.dart';
import 'package:reown_appkit/modal/services/explorer_service/explorer_service_singleton.dart';
import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';
import 'package:reown_appkit/modal/theme/public/appkit_modal_theme.dart';
import 'package:reown_appkit/modal/utils/public/appkit_modal_default_networks.dart';
import 'package:reown_appkit/modal/widgets/buttons/base_button.dart';
import 'package:reown_appkit/modal/widgets/icons/rounded_icon.dart';

class AppKitModalBalanceButton extends StatefulWidget {
  const AppKitModalBalanceButton({
    super.key,
    required this.appKitModal,
    this.size = BaseButtonSize.regular,
    this.onTap,
  });
  static const balanceDefault = '_.__';
  final IReownAppKitModal appKitModal;
  final BaseButtonSize size;
  final VoidCallback? onTap;

  @override
  State<AppKitModalBalanceButton> createState() =>
      _AppKitModalBalanceButtonState();
}

class _AppKitModalBalanceButtonState extends State<AppKitModalBalanceButton> {
  String? _tokenImage;

  @override
  void initState() {
    super.initState();
    _modalNotifyListener();
    widget.appKitModal.addListener(_modalNotifyListener);
  }

  @override
  void dispose() {
    widget.appKitModal.removeListener(_modalNotifyListener);
    super.dispose();
  }

  void _modalNotifyListener() {
    setState(() {
      final chainId = widget.appKitModal.selectedChain?.chainId ?? '1';
      final imageId = ReownAppKitModalNetworks.getNetworkIconId(chainId);
      _tokenImage = explorerService.instance.getAssetImageUrl(imageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ReownAppKitModalTheme.colorsOf(context);
    return BaseButton(
      size: widget.size,
      onTap: widget.onTap,
      buttonStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return themeColors.grayGlass005;
            }
            return themeColors.grayGlass010;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return themeColors.grayGlass015;
            }
            return themeColors.foreground100;
          },
        ),
        shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
          (states) {
            return RoundedRectangleBorder(
              side: states.contains(MaterialState.disabled)
                  ? BorderSide(color: themeColors.grayGlass005, width: 1.0)
                  : BorderSide(color: themeColors.grayGlass010, width: 1.0),
              borderRadius: BorderRadius.circular(widget.size.height / 2),
            );
          },
        ),
      ),
      overridePadding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.only(
          left: 6.0,
          right: widget.size == BaseButtonSize.small ? 12.0 : 16.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoundedIcon(
            imageUrl: _tokenImage,
            size: widget.size.height * 0.55,
          ),
          const SizedBox.square(dimension: 4.0),
          ValueListenableBuilder<String>(
            valueListenable: widget.appKitModal.balanceNotifier,
            builder: (_, balance, __) {
              return Text(balance);
            },
          ),
        ],
      ),
    );
  }
}
