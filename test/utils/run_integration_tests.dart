import '../integration_tests/institution_automation_tests.dart' as institution_test;
import '../integration_tests/input_data_automation_tests.dart' as input_data_test;

// This file is only for you to call the main function from your integration test script.
// After you added your main() here, the integration test driver will run all automation tests in once.
// Steps: 1, import your test file and create an instance of it. 2, Call the main.
void main() {

  // Automation tests for institution test
  institution_test.main();

  //Automation tests for input data test
  input_data_test.main();
}