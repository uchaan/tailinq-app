import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/pet_member.dart';
import '../../providers/pet_provider.dart';

class ParentManagementSection extends ConsumerWidget {
  final String petId;
  final bool isLoading;

  const ParentManagementSection({
    super.key,
    required this.petId,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersState = ref.watch(petMemberNotifierProvider(petId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Manage Parents',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: isLoading ? null : () => _showAddDialog(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        membersState.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: $error',
                style: const TextStyle(color: Colors.red)),
          ),
          data: (members) => _buildMemberList(context, ref, members),
        ),
      ],
    );
  }

  Widget _buildMemberList(
      BuildContext context, WidgetRef ref, List<PetMember> members) {
    if (members.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No parents added yet.'),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < members.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            _buildMemberTile(context, ref, members[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberTile(
      BuildContext context, WidgetRef ref, PetMember member) {
    final initials = (member.userName ?? 'U')
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .take(2)
        .join();

    final roleName =
        member.role.name[0].toUpperCase() + member.role.name.substring(1);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            member.isPrimary ? Theme.of(context).primaryColor : Colors.grey[300],
        foregroundColor: member.isPrimary ? Colors.white : Colors.black87,
        child: Text(initials),
      ),
      title: Row(
        children: [
          Flexible(child: Text(member.userName ?? 'Unknown')),
          if (member.isPrimary) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Primary',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(roleName),
      trailing: member.isPrimary
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.swap_horiz,
                      color: Theme.of(context).primaryColor, size: 20),
                  tooltip: 'Transfer Primary',
                  onPressed: isLoading
                      ? null
                      : () => _showTransferDialog(context, ref, member),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red, size: 20),
                  tooltip: 'Remove',
                  onPressed: isLoading
                      ? null
                      : () => _showRemoveDialog(context, ref, member),
                ),
              ],
            ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    var selectedRole = PetMemberRole.family;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Parent'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter name',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  hintText: 'Enter email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PetMemberRole>(
                initialValue: selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: PetMemberRole.family,
                    child: Text('Family'),
                  ),
                  DropdownMenuItem(
                    value: PetMemberRole.caretaker,
                    child: Text('Caretaker'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => selectedRole = value);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    emailController.text.trim().isEmpty) {
                  return;
                }
                Navigator.of(context).pop(true);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      await ref.read(petMemberNotifierProvider(petId).notifier).addMember(
            email: emailController.text.trim(),
            name: nameController.text.trim(),
            role: selectedRole,
          );
    }

    emailController.dispose();
    nameController.dispose();
  }

  Future<void> _showRemoveDialog(
      BuildContext context, WidgetRef ref, PetMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Parent'),
        content: Text(
            'Are you sure you want to remove ${member.userName ?? 'this member'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(petMemberNotifierProvider(petId).notifier)
          .removeMember(member.id);
    }
  }

  Future<void> _showTransferDialog(
      BuildContext context, WidgetRef ref, PetMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transfer Primary'),
        content: Text(
            'Transfer primary parent role to ${member.userName ?? 'this member'}? You will lose primary privileges.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Transfer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(petMemberNotifierProvider(petId).notifier)
          .transferPrimary(member.id);
    }
  }
}
