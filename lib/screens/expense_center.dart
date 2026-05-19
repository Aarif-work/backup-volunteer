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
  ];

  double get _totalRequestedRefund => _expenses
      .where((e) => e.refundRequested && e.status == ApprovalStatus.pending)
      .fold(0, (sum, item) => sum + item.amount);

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
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating Spreadsheet... (Excel export ready)')),
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
              const Text('AUDIT TRAIL', 
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 1.2)),
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
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddExpenseDialog(context),
          backgroundColor: AppTheme.primaryColor,
          icon: const Icon(Icons.add_a_photo_outlined, color: Colors.white),
          label: const Text('Add Record', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildUtilityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pending Refund', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    '₹ ${_totalRequestedRefund.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 32),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryStat('TOTAL RECORDED', '₹ ${_totalFoundationSpend.toStringAsFixed(0)}'),
              _buildSummaryStat('SUBMISSIONS', '${_expenses.length} Items'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
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
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : AppTheme.textSecondary)),
        selected: isSelected,
        selectedColor: AppTheme.primaryColor,
        onSelected: (val) => setState(() => _filterStatus = status),
      ),
    );
  }

  Widget _buildAuditCard(ExpenseRecord expense) {
    Color statusColor = expense.status == ApprovalStatus.approved ? Colors.green : (expense.status == ApprovalStatus.pending ? Colors.orange : Colors.red);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.receipt_outlined, color: AppTheme.primaryColor, size: 20),
        ),
        title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text('${expense.date.day}/${expense.date.month} • ${expense.category.name}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹ ${expense.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(expense.status.name.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
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
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Optimize for foundation storage
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
    // ... code for date selection remains same ...
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
              const Text('Record New Expense', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Description', hintText: 'e.g. Stationary'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Date'),
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount Spent', prefixText: '₹ '),
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
          const SizedBox(height: 32),
          const Text('PAYMENT TYPE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPaymentTypeOption('MY REFUND', true),
              const SizedBox(width: 12),
              _buildPaymentTypeOption('HOPE3 AMOUNT', false),
            ],
          ),
          const SizedBox(height: 32),
          const Text('EVIDENCE UPLOAD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
          const SizedBox(height: 12),
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
                 );
                 widget.onSubmitted(newExp);
                 Navigator.pop(context);
              }
            },
            child: const Text('SUBMIT FOR AUDIT'),
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
                fontSize: 12, 
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary
              )
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentHub() {
    if (_pickedImage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_pickedImage!.path),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Receipt Captured',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: () => setState(() => _pickedImage = null), 
              icon: const Icon(Icons.refresh, color: Colors.green)
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        _buildAttachmentButton(Icons.camera_alt_outlined, 'Camera', () => _pickImage(ImageSource.camera)),
        const SizedBox(width: 12),
        _buildAttachmentButton(Icons.photo_library_outlined, 'Gallery', () => _pickImage(ImageSource.gallery)),
      ],
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.textSecondary),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
