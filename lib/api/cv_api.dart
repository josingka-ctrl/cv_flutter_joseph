import '../models/account.dart';
import '../models/family_member.dart';

abstract class CvApi {
  Future<Account> login({required String email, required String password});

  Future<Account> register({required String email, required String password});

  Future<List<FamilyMember>> listMembers();

  Future<FamilyMember> createMember(FamilyInput input);

  Future<FamilyMember> updateMember(int id, FamilyInput input);

  Future<void> deleteMember(int id);
}
