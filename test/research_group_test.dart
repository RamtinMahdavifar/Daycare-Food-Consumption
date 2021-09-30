import 'package:test/test.dart';
import 'package:plate_waste_recorder/Model/research_group.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';

// run tests from the terminal using: flutter test test/institution_test.dart
void main(){
  group("research_group getters and setters",() {
    test("research group getters", () {

      final groupOwner = ResearcherInfo("Prof");
      final groupMember1 = ResearcherInfo("Student1");
      final groupMember2 = ResearcherInfo("Student2");
      List<ResearcherInfo> groupMembers = [];
      groupMembers.add(groupMember1);
      groupMembers.add(groupMember2);


      final testresearch_group = ResearchGroup("Test rGroup", groupOwner);

      testresearch_group.addNewMember(groupMember1);
      testresearch_group.addNewMember(groupMember2);



      expect(testresearch_group.name,"Test rGroup");
      expect(testresearch_group.owner, groupOwner);
      expect(testresearch_group.members,groupMembers );
    });

    test("research group setters", () {

      final groupOwner = ResearcherInfo("Prof");
      final groupOwner1 = ResearcherInfo("Student1");

      final testresearch_group = ResearchGroup("Test rGroup", groupOwner);

      testresearch_group.name = "new test name";
      testresearch_group.owner = groupOwner1;
      expect(testresearch_group.name, "new test name");
      expect(testresearch_group.owner, groupOwner1);
    });
  });

  group("research_group members list",() {
    test("add member", () {

      final groupOwner = ResearcherInfo("Prof");



      final testresearch_group = ResearchGroup("Test rGroup", groupOwner);
      expect(testresearch_group.members,[]);

      final groupMember1 = ResearcherInfo("Student1");
      final groupMember2 = ResearcherInfo("Student2");

      List<ResearcherInfo> groupMembers = [];
      groupMembers.add(groupMember1);
      groupMembers.add(groupMember2);
      testresearch_group.addNewMember(groupMember1);
      testresearch_group.addNewMember(groupMember2);
      expect(testresearch_group.members, groupMembers);

    });

    test("remove a member", () {
      final groupOwner = ResearcherInfo("Prof");
      final testresearch_group = ResearchGroup("Test rGroup", groupOwner);
      final groupMember1 = ResearcherInfo("Student1");
      final groupMember2 = ResearcherInfo("Student2");

      List<ResearcherInfo> groupMembers = [];
      groupMembers.add(groupMember1);
      groupMembers.add(groupMember2);
      testresearch_group.addNewMember(groupMember1);
      testresearch_group.addNewMember(groupMember2);
      expect(testresearch_group.members, groupMembers);

      expect(testresearch_group.removeMember(groupMember1), 0);
      expect(testresearch_group.removeMember(groupMember2), 0);

      expect(testresearch_group.members,[]);




    });

    test("remove non existing members", () {

      final groupOwner = ResearcherInfo("Prof");
      final testresearch_group = ResearchGroup("Test rGroup", groupOwner);
      final groupMember1 = ResearcherInfo("Student1");

      expect(testresearch_group.removeMember(groupMember1), -1);


    });
  });




}