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
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          _buildStatusFilter(),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
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
      expandedHeight: 220.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                right: -30,
                child: Icon(Icons.account_balance_wallet_rounded, size: 200, color: Colors.white.withOpacity(0.05)),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Finance Center',
                            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.5),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.description_outlined, color: Colors.white70, size: 20),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generating PDF Report...')));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.download_rounded, color: Colors.white70, size: 20),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel Spreadsheet Exported')));
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      Text(
                        '₹ ${_totalRemainingRefund.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text('Available for Refund', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const Spacer(),
                      Row(
                        children: [
                          _buildHeaderStat('Waiting', '₹ ${_totalRequestedRefund.toStringAsFixed(0)}', Icons.pending_actions_rounded, Colors.orangeAccent),
                          const SizedBox(width: 24),
                          _buildHeaderStat('Recorded', '₹ ${_totalFoundationSpend.toStringAsFixed(0)}', Icons.fact_check_rounded, Colors.blueAccent),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
          ],
        )
      ],
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
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: 1.5),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
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
