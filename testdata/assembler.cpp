#include <bits/stdc++.h>
using namespace std;
//string fetch(string instruction,int p){
//	string str;
//	for(int i=p;i<instruction.size();i++){
//		if(isspace(instruction[i]) && str.size()==0){
//			str[i]='\0';
//			break;
//		}
//		str+=instruction[i];
//	}
//	return str;
//}
//string Num(string instruction,int p){
//	string str;
//	int n=0;
//	for(;p<instruction.size();p++){
//		if(instruction[p]=='x') break;
//	}
//	for(;p<instruction.size();p++){
//		if(instruction[p]==',') break;
//		if(instruction[p]>='0' && instruction[p]<='9'){
//			n*=10;
//			n+=(instruction[p]-'0');
//		}
//	}
//	for(int i=4;i>=0;i--){
//		str+= (n&(1<<i)) ? '1' : '0';
//	}
//	return str;
//}
string bin(int n,int size){
	string str;
	for(int i=size-1;i>=0;i--){
		str+= (n&(1<<i)) ? '1' : '0';
	}
	return str;
}
int main(){
	//freopen("instruction.txt","r", stdin);
	//freopen("machinecode.txt","w",stdout);
	char c;
	string instruction,str,opcode,funct3,funct7,rd,rs1,rs2,imm;
	while(getline(cin,instruction)){
	    stringstream ss;
		ss<<instruction;
		ss>>str;
		if(str=="or"){
			opcode="0110011";
			funct3="110";
			funct7="0000000";
			int n;
			ss>>c>>n>>c;
			rd=bin(n,5);
			ss>>c>>n>>c;
			rs1=bin(n,5);
			ss>>c>>n;
			rs2=bin(n,5);
			cout<<funct7<<rs2<<rs1<<funct3<<rd<<opcode<<"//"<<instruction<<'\n';
		} 
		else if(str=="and"){
			opcode="0110011";
			funct3="111";
			funct7="0000000";
			int n;
			ss>>c>>n>>c;
			rd=bin(n,5);
			ss>>c>>n>>c;
			rs1=bin(n,5);
			ss>>c>>n;
			rs2=bin(n,5);
			cout<<funct7<<rs2<<rs1<<funct3<<rd<<opcode<<"//"<<instruction<<'\n';
		}
		else if(str=="add"){
			opcode="0110011";
			funct3="000";
			funct7="0000000";
			int n;
			ss>>c>>n>>c;
			rd=bin(n,5);
			ss>>c>>n>>c;
			rs1=bin(n,5);
			ss>>c>>n;
			rs2=bin(n,5);
			cout<<funct7<<rs2<<rs1<<funct3<<rd<<opcode<<"//"<<instruction<<'\n';
		}
		else if(str=="sub"){
			opcode="0110011";
			funct3="000";
			funct7="0100000";
			int n;
			ss>>c>>n>>c;
			rd=bin(n,5);
			ss>>c>>n>>c;
			rs1=bin(n,5);
			ss>>c>>n;
			rs2=bin(n,5);
			cout<<funct7<<rs2<<rs1<<funct3<<rd<<opcode<<"//"<<instruction<<'\n';
		}
		else if(str=="mul"){
				opcode="0110011";
				funct3="000";
				funct7="0000001";
				int n;
				ss>>c>>n>>c;
				rd=bin(n,5);
				ss>>c>>n>>c;
				rs1=bin(n,5);
				ss>>c>>n;
				rs2=bin(n,5);
				cout<<funct7<<rs2<<rs1<<funct3<<rd<<opcode<<"//"<<instruction<<'\n';
		}
		else if(str=="addi"){
			opcode="0010011";
			funct3="000";
			int n;
			ss>>c>>n>>c;
			rd=bin(n,5);
			ss>>c>>n>>c;
			rs1=bin(n,5);
			ss>>n;
			imm=bin(n,12);
			cout<<imm<<rs1<<funct3<<rd<<opcode<<"//"<<instruction<<'\n';
		}
		else if(str=="lw"){
			opcode="0000011";
			funct3="010";
			int n;
			ss>>c>>n>>c;
			rd=bin(n,5);
			ss>>n>>c;
			rs1=bin(n,5);
			ss>>c>>n>>c;
			imm=bin(n,12);
			cout<<imm<<rs1<<funct3<<rd<<opcode<<"//"<<instruction<<'\n';
		}
		else if(str=="sw"){
			opcode="0100011";
			funct3="010"; 
			int n;
			ss>>c>>n>>c;
			rs2=bin(n,5);
			ss>>n>>c;
			imm=bin(n,12);
			ss>>c>>n>>c;
			rs1=bin(n,5);
			cout<<imm.substr(0,7)<<rs2<<rs1<<funct3<<imm.substr(7,5)<<opcode<<"//"<<instruction<<'\n';
		}
		else if(str=="beq"){
			opcode="1100011";
			funct3="000";
			int n;
			ss>>c>>n>>c;
			rs1=bin(n,5);
			ss>>c>>n>>c;
			rs2=bin(n,5);
			ss>>n;
			n*=2;
			imm=bin(n,12);
			cout<<imm[0]<<imm.substr(2,6)<<rs2<<rs1<<funct3<<imm.substr(8,4)<<imm[1]<<opcode<<"//"<<instruction<<'\n';
		}
	}
	return 0;
}
