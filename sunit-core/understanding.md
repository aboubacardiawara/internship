# Sunit core
## How tests are run ?
There are several way to run a test.
- without UI.
    - running single test: `MyTestCase runCase: selector`
        - Doute: does running a single test require creating a suite ? 
    - running a group of test: `MyTestCase suite run`
- with UI:
    - Browser: circular button next to the test method.
    - TestRunner: user interface where we have the possibility to run a group of test and to do other operaitons (profiling, coverage, ...)
    - DrTest:
## How a test suite is created
A test suite contains:
- tests: a collection of tests to run. These tests belong to the same TestCase.
- ressources: the ressources required by the TestCase execution. For example, imagine we want to test that some requests (simple selection, double jointure, ...), on a giving relationnal database, duration is lower or equals to 1 ms. We need first to etablish a connexion, but not at every test method execution (one connexion for all test method is enough). The connexion can be considered as one of the TestCase ressource.
- name:
- annoucer:
...
To create a test suite, the message suite is sent to the Testcase. the result is a TestSuite.
Each methods of the class will be add to collection of tests if it name begin by test (it i why each test method name should begin with test).
## How does it change when it is a parametrized ?
To create a test suite for parametrized test, we send the same message to the test class.
But testParametrize return an matrix. 
All possible combinaison of that result will be considered. 
    - And for each combinaison, a temporary suite is created. 
    - Then when the temporary suite is completely build (all method with test at the beign of it name), it contain will be transfered in the final suite.
    - we continue for the remaining combinaisons.    

## how the asserts / errors work ?
### assert
Use to write test, it check of the evaluation of the giving block is true. If not, an error is throwed. There are many alternative:
- assert: equals:
- assert: description:
- should: raise
- deny:
- ...
The following test will pass 
```smalltalk
testThatWillPass
    self assert: 2 equals: 2
```
### failure
Occured when the feature under test doesn't not responds to the specification.
The following test will fail:
```smalltalk
testThatWillPass
    self assert: 2 equals: 3
```
### errors
Error occured when we wrote incorrect instruction.
The following test will raise an error.
```smalltalk
testThatWillPass
    aBook := Book new. "we assume the Book exists"
    self deny: aBook isOld "we assume again Book understand the message isOld which returns a boolean"
```
because aBook has not been declared as local variable.
## How the skip works ?
a skip test is supposed to be skipped. whether it passes or fails, it will be in the collection of skipped tests (see TestResult).
To skip a test, we send it the message skip. `self skip`
## What information is in test result ?
- failures: collection of tests wich did not meet the specification.
- erros: collection of tests wich did not respect the langage rules (syntaxic erros, sending message to object which can't understand it).
- passed: collection of tests which that met the specification.
- sipped: collection of tests which has been skipped.
- timeStamp: todo