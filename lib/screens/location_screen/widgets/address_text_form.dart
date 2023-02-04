import 'package:flutter/material.dart';

class AddressForm extends StatefulWidget {
  AddressForm({super.key, required this.onTap, required this.title});
  dynamic onTap;
  String? title;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: ListTile(
                  title: Text(
                    widget.title!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  trailing: const Icon(Icons.search),
                  dense: true,
                )),
          ),
        ));
  }
}
