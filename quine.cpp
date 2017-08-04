#include<stdio.h>
static char special[] = "\n\"\\\t";
int main() {
	char *text="#include<stdio.h>%cstatic char special[] = %c%cn%c%c%c%c%ct%c;%cint main() {%c%cchar *text=%c%s%c;%c%cprintf(text,special[0],special[1],special[2],special[2],special[1],special[2],special[2],special[2],special[1],special[0],special[0],special[3],special[1],text,special[1],special[0],special[3],special[0],special[3],special[0],special[0],special[0],special[0],special[0],special[0],special[0],special[0],special[0]);%c%creturn 0;%c}%c/**%c *%c * Create a program that write yourself%c *%c * @author jeremias%c *%c */%c";
	printf(text,special[0],special[1],special[2],special[2],special[1],special[2],special[2],special[2],special[1],special[0],special[0],special[3],special[1],text,special[1],special[0],special[3],special[0],special[3],special[0],special[0],special[0],special[0],special[0],special[0],special[0],special[0],special[0]);
	return 0;
}
/**
 *
 * Create a program that write itself
 *
 * @author jeremias
 *
 */
