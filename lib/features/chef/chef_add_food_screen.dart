import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../data/chef_data.dart';
import '../../state/app_state.dart';
import 'chef_widgets.dart';

/// Add new Items: шинэ хоол нэмэх. Хадгалсан хоол хэрэглэгчийн талд шууд гарна.
class ChefAddFoodScreen extends StatefulWidget {
  const ChefAddFoodScreen({super.key});

  @override
  State<ChefAddFoodScreen> createState() => _ChefAddFoodScreenState();
}

class _ChefAddFoodScreenState extends State<ChefAddFoodScreen> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _desc = TextEditingController();

  String _meal = 'Өдөр';
  bool _pickup = true;
  bool _delivery = false;
  int _photos = 1;
  bool _showAllMain = false;
  bool _showAllExtra = false;
  final Set<String> _selected = {'Давс', 'Сонгино'};

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      _name.clear();
      _price.clear();
      _desc.clear();
      _meal = 'Өдөр';
      _pickup = true;
      _delivery = false;
      _photos = 1;
      _selected.clear();
    });
  }

  void _save() {
    final name = _name.text.trim();
    final price = int.tryParse(_price.text.replaceAll(RegExp(r'[^0-9]'), ''));
    if (name.isEmpty) {
      _toast('Хоолны нэрээ оруулна уу');
      return;
    }
    if (price == null || price <= 0) {
      _toast('Үнээ зөв оруулна уу');
      return;
    }
    if (!_pickup && !_delivery) {
      _toast('Очиж авах эсвэл хүргэлтээс сонгоно уу');
      return;
    }
    AppScope.of(context).addChefFood(
      name: name,
      price: price,
      meal: _meal,
      ingredients: _selected.toList(),
      description: _desc.text.trim(),
    );
    _toast('"$name" нэмэгдлээ. Хэрэглэгчид харагдана.');
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.chefFoods);
    }
  }

  void _toast(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return ChefScaffold(
      body: Column(
        children: [
          ChefHeader(
            title: 'Шинэ хоол нэмэх',
            actionLabel: 'ЦЭВЭРЛЭХ',
            onAction: _clear,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              children: [
                const _Label('ХООЛНЫ НЭР'),
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(hintText: 'Тахианы Бирьяни'),
                ),
                const SizedBox(height: 16),
                const _Label('ЗУРАГ / ВИДЕО НЭМЭХ'),
                // Жинхэнэ зураг сонгохдоо `image_picker` багц нэмнэ.
                SizedBox(
                  height: 76,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var i = 0; i < _photos; i++)
                        Container(
                          width: 76,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE9C7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.local_pizza,
                            color: Color(0xFFE59A4B),
                            size: 34,
                          ),
                        ),
                      for (var i = 0; i < 2; i++)
                        GestureDetector(
                          onTap: () => setState(() => _photos++),
                          child: Container(
                            width: 76,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(height: 2),
                                Text('Нэмэх', style: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const _Label('ҮНЭ'),
                Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: TextField(
                        controller: _price,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(hintText: '₮50,000'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _Check(
                      label: 'Очиж авах',
                      value: _pickup,
                      onChanged: (v) => setState(() => _pickup = v),
                    ),
                    _Check(
                      label: 'Хүргэлт',
                      value: _delivery,
                      onChanged: (v) => setState(() => _delivery = v),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _Label('ХООЛНЫ ЦАГ'),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final m in ChefData.meals)
                      ChoiceChip(
                        label: Text(m),
                        selected: _meal == m,
                        selectedColor: const Color(0xFFE7F3D2),
                        onSelected: (_) => setState(() => _meal = m),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const _Label('ОРЦЫН ЖАГСААЛТ'),
                _IngredientGroup(
                  title: 'Үндсэн орц',
                  items: ChefData.mainIngredients,
                  selected: _selected,
                  expanded: _showAllMain,
                  onToggleExpand: () =>
                      setState(() => _showAllMain = !_showAllMain),
                  onToggle: (n) => setState(() {
                    if (!_selected.remove(n)) _selected.add(n);
                  }),
                ),
                const SizedBox(height: 12),
                _IngredientGroup(
                  title: 'Нэмэлт орц',
                  items: ChefData.extraIngredients,
                  selected: _selected,
                  expanded: _showAllExtra,
                  onToggleExpand: () =>
                      setState(() => _showAllExtra = !_showAllExtra),
                  onToggle: (n) => setState(() {
                    if (!_selected.remove(n)) _selected.add(n);
                  }),
                ),
                const SizedBox(height: 16),
                const _Label('ДЭЛГЭРЭНГҮЙ ТАЙЛБАР'),
                TextField(
                  controller: _desc,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText:
                        'Энэ хоолны орц, амт, онцлог болон бэлтгэх арга талаар бичнэ үү.',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: AppButton(label: 'ХАДГАЛАХ', onPressed: _save),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: value ? const Color(0xFFE5604F) : AppColors.textSecondary,
            ),
            const SizedBox(width: 3),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _IngredientGroup extends StatelessWidget {
  const _IngredientGroup({
    required this.title,
    required this.items,
    required this.selected,
    required this.expanded,
    required this.onToggleExpand,
    required this.onToggle,
  });

  final String title;
  final List<Ingredient> items;
  final Set<String> selected;
  final bool expanded;
  final VoidCallback onToggleExpand;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final bubbles = [
      for (final i in items)
        IngredientBubble(
          name: i.name,
          icon: i.icon,
          selected: selected.contains(i.name),
          onTap: () => onToggle(i.name),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: onToggleExpand,
              child: Text(
                expanded ? 'Хураах' : 'Бүгдийг харах',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (expanded)
          Wrap(spacing: 8, runSpacing: 10, children: bubbles)
        else
          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: bubbles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => bubbles[i],
            ),
          ),
      ],
    );
  }
}
