#include <stdlib.h>
#include "includes/sqrt.h"

int
main( int argc, char *argv[] ) {
  if ( argc > 1 ) {
    print_sqrt( atof( argv[ 1 ] ) );
  }
  return 0;
}