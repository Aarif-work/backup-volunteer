import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

class ExpenseCenterScreen extends StatefulWidget {
  const ExpenseCenterScreen({super.key});

  @override
  State<ExpenseCenterScreen> createState() => _ExpenseCenterScreenState();
}

class _ExpenseCenterScreenState extends State<ExpenseCenterScreen> {
  ApprovalStatus? _filterStatus;
  final ScrollController _scrollController = ScrollController();
  
  final List<ExpenseRecord> _expenses = [
    ExpenseRecord(
      id: '1',
      title: 'Volunteer Refreshments',
      description: 'Water and snacks for 20 people.',
      category: ExpenseCategory.snacks,
      amount: 450.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: ApprovalStatus.approved,
      refundRequested: true,
      approvedAmount: 450.0,
      receivedAmount: 450.0,
    ),
    ExpenseRecord(
      id: '2',
      title: 'Diesel for Logistics',
      description: 'Used for transport truck.',
      category: ExpenseCategory.travel,
      amount: 1800.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: ApprovalStatus.pending,
      refundRequested: true,
    ),
    ExpenseRecord(
      id: '3',
      title: 'Private Event Props',
      description: 'Personal storage record.',
      category: ExpenseCategory.other,
      amount: 120.0,
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: ApprovalStatus.approved,
      isPrivate: true,
    ),
  ];

  double get _totalRequestedRefund => _expenses
      .where((e) => e.refundRequested && e.status == ApprovalStatus.pending)
      .fold(0, (sum, item) => sum + item.amount);

  double get _totalRemainingRefund => _expenses
      .where((e) => e.refundRequested && e.status == ApprovalStatus.approved)
      .fold(0, (sum, item) => sum + item.remainingBalance);

  double get _totalFoundationSpend => _expenses
      .fold(0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    List<ExpenseRecord> filteredExpenses = _expenses;
    if (_filterStatus != null) {
      filteredExpenses = _expenses.where((e) => e.status == _filterStatus).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          _buildStatsSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          _buildStatusFilter(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildModernAuditCard(filteredExpenses[index]),
                childCount: filteredExpenses.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(context),
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Record', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFFF8F9FA),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      title: const Text('Finance Center', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
    );
  }

  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Available for Refund', style: TextStyle(color: AppTheme.secondaryText, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('₹', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryText, height: 1.0)),
                    const SizedBox(width: 4),
                    Text(_totalRemainingRefund.toStringAsFixed(0), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.primaryText, height: 1.0)),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.pending_actions_rounded, color: Colors.orange, size: 14),
                      const SizedBox(width: 6),
                      Text('Wait: ₹${_totalRequestedRefund.toStringAsFixed(0)}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.fact_check_rounded, color: Colors.blue, size: 14),
                      const SizedBox(width: 6),
                      Text('Paid: ₹${_totalFoundationSpend.toStringAsFixed(0)}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            _buildFilterChip('All Records', null),
            _buildFilterChip('Pending', ApprovalStatus.pending),
            _buildFilterChip('Approved', ApprovalStatus.approved),
            _buildFilterChip('Rejected', ApprovalStatus.rejected),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, ApprovalStatus? status) {
    bool isSelected = _filterStatus == status;
    return GestureDetector(
      onTap: () => setState(() => _filterStatus = status),
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? AppTheme.peachAccent : Colors.transparent, width: 3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.peachAccent : Colors.grey, 
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, 
            fontSize: 15
          ),
        ),
      ),
    );
  }

  Widget _buildModernAuditCard(ExpenseRecord expense) {
    Color statusColor = expense.status == ApprovalStatus.approved ? AppTheme.accentColor : (expense.status == ApprovalStatus.pending ? Colors.orange : Colors.red);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: expense.isPrivate ? Colors.grey.shade100 : statusColor.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(20)
            ),
            child: Icon(
              expense.isPrivate ? Icons.lock_outline_rounded : Icons.receipt_long_rounded, 
              color: expense.isPrivate ? Colors.grey : statusColor, 
              size: 24
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)
                ),
                const SizedBox(height: 4),
                Text(
                  '${expense.date.day}/${expense.date.month} • ${expense.category.name.toUpperCase()}', 
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹ ${expense.amount.toStringAsFixed(0)}', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryText)
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  expense.status.name.toUpperCase(), 
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExpenseForm(
        onSubmitted: (newExpense) {
          setState(() {
            _expenses.insert(0, newExpense);
          });
        },
      ),
    );
  }
}

// Keep AddExpenseForm the same
class AddExpenseForm extends StatefulWidget {
  final Function(ExpenseRecord) onSubmitted;
  const AddExpenseForm({super.key, required this.onSubmitted});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.snacks;
  DateTime _selectedDate = DateTime.now();
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Record', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryText)
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.secondaryText), 
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Title / Description
          _buildFriendlyTextField(
            controller: _titleController,
            label: 'Description',
            hint: 'e.g. Bulk Stationary for Unit B',
            icon: Icons.edit_note_rounded,
          ),
          const SizedBox(height: 20),

          // Amount and Category
          Row(
            children: [
              Expanded(
                child: _buildFriendlyTextField(
                  controller: _amountController,
                  label: 'Amount',
                  hint: '0.00',
                  icon: Icons.currency_rupee_rounded,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.secondaryText)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ExpenseCategory>(
                          value: _category,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.secondaryText),
                          items: ExpenseCategory.values.map((c) => DropdownMenuItem(
                            value: c, 
                            child: Text(c.name.toUpperCase(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                          )).toList(),
                          onChanged: (v) => setState(() => _category = v!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          _buildAttachmentHub(),
          
          const Spacer(),
          
          // Save Button
          GestureDetector(
            onTap: () {
              if (_titleController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                 final amount = double.tryParse(_amountController.text) ?? 0.0;
                 final newExp = ExpenseRecord(
                   id: DateTime.now().toString(),
                   title: _titleController.text,
                   description: '',
                   category: _category,
                   amount: amount,
                   date: _selectedDate,
                   refundRequested: true,
                   status: ApprovalStatus.pending,
                   isPrivate: false,
                   isFoundationPaid: false,
                 );
                 widget.onSubmitted(newExp);
                 Navigator.pop(context);
              }
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: const Center(
                child: Text('SAVE RECORD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1.0)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFriendlyTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.secondaryText)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1.5),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppTheme.primaryText, fontSize: 15, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.secondaryText, size: 20),
              hintText: hint,
              hintStyle: TextStyle(color: AppTheme.secondaryText.withOpacity(0.5), fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentHub() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PROOF OF EXPENSE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.secondaryText, letterSpacing: 1.0)),
        const SizedBox(height: 16),
        if (_pickedImage != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.green[200]!)),
            child: Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(_pickedImage!.path), width: 40, height: 40, fit: BoxFit.cover)),
                const SizedBox(width: 12),
                const Expanded(child: Text('Receipt Captured', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13))),
                IconButton(onPressed: () => setState(() => _pickedImage = null), icon: const Icon(Icons.close, color: Colors.green, size: 20)),
              ],
            ),
          )
        else
          Row(
            children: [
              _buildAttachmentButton(Icons.camera_alt_outlined, 'Camera', () => _pickImage(ImageSource.camera)),
              const SizedBox(width: 16),
              _buildAttachmentButton(Icons.photo_library_outlined, 'Gallery', () => _pickImage(ImageSource.gallery)),
            ],
          ),
      ],
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1.5), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.secondaryText, size: 20),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
