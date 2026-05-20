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
  
  // Local state for persistence during the session
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Finance Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating PDF Report...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Excel Spreadsheet Exported')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUtilityCard(),
              const SizedBox(height: 32),
              _buildStatusFilter(),
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('AUDIT TRAIL', 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1.2)),
                  Icon(Icons.filter_list, size: 16, color: AppTheme.textSecondary),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final exp = _expenses[index];
                  if (_filterStatus != null && exp.status != _filterStatus) {
                    return const SizedBox.shrink();
                  }
                  return _buildAuditCard(exp);
                },
              ),
               const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(context),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text('Add Records', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildUtilityCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade100, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available for Refund', style: TextStyle(color: AppTheme.secondaryText, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    '₹ ${_totalRemainingRefund.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppTheme.primaryText, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  gradient: AppTheme.warmSunsetGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryStat('WAITING', '₹ ${_totalRequestedRefund.toStringAsFixed(0)}', AppTheme.peachAccent),
              _buildSummaryStat('TOTAL RECORDED', '₹ ${_totalFoundationSpend.toStringAsFixed(0)}', AppTheme.primaryText),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: valueColor, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All Records', null),
          _buildFilterChip('Pending', ApprovalStatus.pending),
          _buildFilterChip('Approved', ApprovalStatus.approved),
          _buildFilterChip('Rejected', ApprovalStatus.rejected),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ApprovalStatus? status) {
    bool isSelected = _filterStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) => setState(() => _filterStatus = status),
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: isSelected ? AppTheme.primaryColor : Colors.grey[200]!)),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildAuditCard(ExpenseRecord expense) {
    Color statusColor = expense.status == ApprovalStatus.approved ? AppTheme.accentColor : (expense.status == ApprovalStatus.pending ? Colors.orange : Colors.red);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[50]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: expense.isPrivate ? Colors.grey[50] : AppTheme.primaryLight, 
            borderRadius: BorderRadius.circular(18)
          ),
          child: Icon(
            expense.isPrivate ? Icons.lock_outline_rounded : Icons.receipt_long_rounded, 
            color: expense.isPrivate ? Colors.grey : AppTheme.primaryColor, 
            size: 22
          ),
        ),
        title: Text(
          expense.title, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${expense.date.day}/${expense.date.month} • ${expense.category.name.toUpperCase()}', 
            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹ ${expense.amount.toStringAsFixed(0)}', 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)
            ),
            const SizedBox(height: 4),
            Text(
              expense.status.name.toUpperCase(), 
              style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)
            ),
          ],
        ),
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
  bool _isReimbursable = true;
  bool _isPrivate = false;
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
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimary,
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
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add Financial Record', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title / Description', hintText: 'e.g. Bulk Stationary for Unit B'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount', prefixText: '₹ '),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<ExpenseCategory>(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ExpenseCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('VISIBILITY & PRIVACY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  title: const Text('Private Storage', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Only visible to you', style: TextStyle(fontSize: 11)),
                  value: _isPrivate,
                  onChanged: (v) => setState(() => _isPrivate = v),
                  activeColor: AppTheme.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('PAYMENT DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPaymentTypeOption('REFUND REQUEST', true),
              const SizedBox(width: 12),
              _buildPaymentTypeOption('FOUNDATION PAID', false),
            ],
          ),
          const SizedBox(height: 24),
          _buildAttachmentHub(),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                 final amount = double.tryParse(_amountController.text) ?? 0.0;
                 final newExp = ExpenseRecord(
                   id: DateTime.now().toString(),
                   title: _titleController.text,
                   description: '',
                   category: _category,
                   amount: amount,
                   date: _selectedDate,
                   refundRequested: _isReimbursable,
                   status: ApprovalStatus.pending,
                   isPrivate: _isPrivate,
                   isFoundationPaid: !_isReimbursable,
                 );
                 widget.onSubmitted(newExp);
                 Navigator.pop(context);
              }
            },
            child: const Text('SAVE RECORD'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildPaymentTypeOption(String label, bool value) {
    bool isSelected = _isReimbursable == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isReimbursable = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.grey[200]!),
          ),
          child: Center(
            child: Text(
              label, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 11, 
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary
              )
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentHub() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PROOF OF EXPENSE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
        const SizedBox(height: 12),
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
              const SizedBox(width: 12),
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
          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.textSecondary, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
