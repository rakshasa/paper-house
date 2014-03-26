Feature: PaperHouse::ExecutableTask

  PaperHouse provides a rake task called `PaperHouse::ExecutableTask`
  to build an executable from *.c and *.h files. These source files
  can be located in multiple subdirectories.

  Scenario: Build an executable from one *.c file
    Given the current project directory is "examples/executable"
    When I run rake "hello"
    Then the stderr should contain:
    """
    gcc -H -fPIC -I. -c hello.c -o ./hello.o
    gcc -o ./hello ./hello.o
    """
    And a file named "hello" should exist
    And I successfully run `./hello`
    And the output should contain "Hello, PaperHouse!"

  Scenario: Build an executable from one *.c file using llvm-gcc by specifying `CC=` option
    Given the current project directory is "examples/executable"
    When I run rake "hello CC=llvm-gcc"
    Then the stderr should contain:
    """
    llvm-gcc -H -fPIC -I. -c hello.c -o ./hello.o
    llvm-gcc -o ./hello ./hello.o
    """
    And a file named "hello" should exist
    And I successfully run `./hello`
    And the output should contain "Hello, PaperHouse!"
    
  Scenario: Build an executable from one *.c file using llvm-gcc
    Given the current project directory is "examples/executable"
    When I run rake "-f Rakefile.llvm hello"
    Then the stderr should contain:
    """
    llvm-gcc -H -fPIC -I. -c hello.c -o ./hello.o
    llvm-gcc -o ./hello ./hello.o
    """
    And a file named "hello" should exist
    And I successfully run `./hello`
    And the output should contain "Hello, PaperHouse!"
    
  Scenario: Build an executable from multiple *.c and *.h files in subdirectories
    Given the current project directory is "examples/executable_subdirs"
    When I run rake "hello"
    Then the stderr should contain:
    """
    mkdir -p objects
    gcc -H -Wall -Wextra -fPIC -Iincludes -Isources -c sources/hello.c -o objects/hello.o
    gcc -H -Wall -Wextra -fPIC -Iincludes -Isources -c sources/main.c -o objects/main.o
    gcc -o objects/hello objects/hello.o objects/main.o
    """
    And a file named "objects/hello" should exist
    And I successfully run `./objects/hello`
    And the output should contain "Hello, PaperHouse!"

  Scenario: Clean
    Given the current project directory is "examples/executable"
    And I successfully run `rake hello`
    When I successfully run `rake clean`
    Then a file named "hello.o" should not exist
    And a file named ".hello.depends" should exist
    And a file named "hello" should exist

  Scenario: Clobber
    Given the current project directory is "examples/executable"
    And I successfully run `rake hello`
    When I successfully run `rake clobber`
    Then a file named "hello.o" should not exist
    And a file named ".hello.depends" should not exist
    And a file named "hello" should not exist

  Scenario: Failure
    Given the current project directory is "examples/fail"
    When I run `rake hello`
    Then the exit status should not be 0
    And the stderr should contain "failed with status"
