
#
# default definitions for Unix utilities (may be changed here)
CC = gcc
RM = rm -f
HARDLN = ln
MKDIR = mkdir -p

# The following variable indicates the architecture of the output binaries
# on using this Makefile.

BITS = 64

#############################################################################
## General compiler options                                                ##
#############################################################################

DEFINES = -DLINUX -D_GCC3
#Note: Append the path to appropriate LDAP headers if not already present
#in the include list.
INCLUDES = -I/opt/ibm/ldap/V6.3.1/include -I../include -I/usr/include 

#############################################################################
## Options for building 64 bit targets on AMD64 Linux
#############################################################################
 CLIENT_LIBS = -lidsldif -libmldap -libmldapdbg -lidsldapiconv
 LIBS = -L/opt/ibm/ldap/V6.3.1/lib64 -L/usr/lib64 -lpthread -ldl

 LFLAGS = -Wl,-rpath,/opt/ibm/ldap/V6.3.1/lib64 $(LIBS) $(CLIENT_LIBS)
 CFLAGS = $(INCLUDES) $(DEFINES)  
#############################################################################
## Targets                                                                 ##
#############################################################################

all: ldapsearch ldapmodify ldapdelete ldapmodrdn ldapadd ldapchangepwd ldapexop

ldapsearch:	
	$(MKDIR) $(BITS)
	$(CC) $(CFLAGS) -o $(BITS)/$@ ldapsearch.c $(LFLAGS)

ldapmodify:
	$(MKDIR) $(BITS)
	$(CC) $(CFLAGS) -o $(BITS)/$@ ldapmodify.c $(LFLAGS)

ldapdelete:
	$(MKDIR) $(BITS)
	$(CC) $(CFLAGS) -o $(BITS)/$@ ldapdelete.c $(LFLAGS)

ldapmodrdn:
	$(MKDIR) $(BITS)
	$(CC) $(CFLAGS) -o $(BITS)/$@ ldapmodrdn.c $(LFLAGS)

ldapchangepwd:
	$(MKDIR) $(BITS)
	$(CC) $(CFLAGS) -o $(BITS)/$@ ldapchangepwd.c $(LFLAGS)

ldapexop:
	$(MKDIR) $(BITS)
	$(CC) $(CFLAGS) -o $(BITS)/$@ ldapexop.c $(LFLAGS)

ldapadd:	ldapmodify
	$(RM) $(BITS)/$@
	$(HARDLN) $(BITS)/ldapmodify $(BITS)/ldapadd

clean:	
	$(RM) *.o core a.out $(BITS)/*.o $(BITS)/core $(BITS)/a.out $(BITS)/ldapsearch \
      $(BITS)/ldapmodify $(BITS)/ldapdelete \
		$(BITS)/ldapmodrdn $(BITS)/ldapadd $(BITS)/ldapchangepwd $(BITS)/ldapexop

