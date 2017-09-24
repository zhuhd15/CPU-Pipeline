#include <iostream>
#include<fstream>
#include<sstream>
#include <string>
#include <vector>
#include <climits>
#include <unordered_map>

using namespace std;

std::unordered_map<string, int> reg;
std::unordered_map<string, int> opc;
std::unordered_map<string, int> funct;
std::unordered_map<string, int> type;

int str2int(const string &s){
	int n = 0;
	if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) {
		for (int i = 2; i < s.length(); i++) {
			n *= 16;
			if (s[i] <= 'f' && s[i] >= 'a') {
				n = n + 10 + s[i] - 'a';
			}
			else if (s[i] <= 'F' && s[i] >= 'A') {
				n = n + 10 + s[i] - 'A';
			}
			else {
				n = n + s[i] - '0';
			}
		}
		return n;
	}
	else {
		stringstream ss(s);
		ss >> n;
		return n;
	}
}

string bin4_0x(char i) {
	switch (i) {
	case '0': return string("0000");
	case '1': return string("0001");
	case '2': return string("0010");
	case '3': return string("0011");
	case '4': return string("0100");
	case '5': return string("0101");
	case '6': return string("0110");
	case '7': return string("0111");
	case '8': return string("1000");
	case '9': return string("1001");
	case 'a': 
	case 'A': return string("1010");
	case 'b': 
	case 'B': return string("1011");
	case 'c': 
	case 'C': return string("1100");
	case 'd': 
	case 'D': return string("1101");
	case 'e': 
	case 'E': return string("1110");
	case 'f': 
	case 'F': return string("1111");
	default:
		cout << "error! hex code invalid" << endl;
		system("pause");
		return string("");
	}
}

string bin16_0x(string i) {
	return bin4_0x(i[2]) + bin4_0x(i[3]) + bin4_0x(i[4]) + bin4_0x(i[5]);
}

int min(int a, int b, int c) {
	int temp = a < b ? a : b;
	return(c < temp ? c : temp);
}

int mymin(int a, int b, int c) {
	//全为-1返回-1, 不全为-1返回非-1最小值
	if (a == -1 && b == -1 && c == -1)
		return -1;
	else
		return min(a < 0 ? INT_MAX : a, b < 0 ? INT_MAX : b, c < 0 ? INT_MAX : c);
}

string bin5(int x) {
	char s[6] = { 0 };
	for (int i = 4; i >= 0; i--) {
		s[i] = '0' + x % 2;
		x /= 2;
	}
	return string(s);
}

string bin6(int x) {
	char s[7] = { 0 };
	for (int i = 5; i >= 0; i--) {
		s[i] = '0' + x % 2;
		x /= 2;
	}
	return string(s);
}

string buma(string s) {
	char r[17] = { 0 };
	r[0] = '1';
	for (int i = 1; i < 16; i++) {
		r[i] = (s[i] == '0') ? '1' : '0';
	}
	for (int i = 15; i > 0; i--) {
		if (r[i] == '1') {
			r[i] = '0';
		}
		else {
			r[i] = '1';
			break;
		}
	}
	return string(r);
}

string bin16(int x) {
	bool minus = x < 0;
	char s[17] = { 0 };
	s[0] = '0';
	if (minus) x = -x;
	for (int i = 15; i > 0; i--) {
		s[i] = '0' + x % 2;
		x /= 2;
	}
	return minus ? buma(string(s)) : string(s);
}

//string bin16u(int x) {
//	char s[17] = { 0 };
//	for (int i = 15; i >= 0; i--) {
//		s[i] = '0' + x % 2;
//		x /= 2;
//	}
//	return string(s);
//}

string bin26(int x) {
	x %= 67108864;	//2**26
	char s[27] = { 0 };
	for (int i = 25; i >= 0; i--) {
		s[i] = '0' + x % 2;
		x /= 2;
	}
	return string(s);
}

string rb5(string r) {
	return bin5(reg[r]);
}
string ib5(string i) {
	return bin5(str2int(i));
}
string ib16(string i) {
	if (i[0] == '0' && (i[1] == 'x' || i[1] == 'X'))
		return bin16_0x(i);
	else
		return bin16(str2int(i));
}
//string ib16u(string i) {
//	return bin16u(str2int(i));
//}
string ib26(string i) {
	return bin26(str2int(i));
}
string fb6(string i) {
	return bin6(funct[i]);
}
string ob6(string i) {
	return bin6(opc[i]);
}



class Label_PC {
public:
	string Label;
	int PC;	//	PC/4
	Label_PC(string L, int P) : Label(L), PC(P) {};
	Label_PC(const Label_PC &LPC): Label(LPC.Label), PC(LPC.PC) {};
	~Label_PC() {};
};

vector<string> Words;
vector<Label_PC> Labels;



int main() {
	ios::sync_with_stdio(false);
	//reg_bin
	{	reg["$zero"] = 0; reg["$0"] = 0;
		reg["$at"] = 1; reg["$v0"] = 2;
		reg["$v1"] = 3; reg["$a0"] = 4;
		reg["$a1"] = 5; reg["$a2"] = 6;
		reg["$a3"] = 7; reg["$t0"] = 8;
		reg["$t1"] = 9; reg["$t2"] = 10;
		reg["$t3"] = 11; reg["$t4"] = 12;
		reg["$t5"] = 13; reg["$t6"] = 14;
		reg["$t7"] = 15; reg["$s0"] = 16;
		reg["$s1"] = 17; reg["$s2"] = 18;
		reg["$s3"] = 19; reg["$s4"] = 20;
		reg["$s5"] = 21; reg["$s6"] = 22;
		reg["$s7"] = 23; reg["$t8"] = 24;
		reg["$t9"] = 25; reg["$k0"] = 26;
		reg["$k1"] = 27; reg["$gp"] = 28;
		reg["$sp"] = 29; reg["$fp"] = 30;
		reg["$ra"] = 31;
	}
	//ins_opcode
	{	
		opc["lw"] = 0x23; opc["sw"] = 0x2b;	opc["lui"] = 0x0f;
		opc["add"] = 0; opc["addu"] = 0;
		opc["sub"] = 0; opc["subu"] = 0;
		opc["addi"] = 0x08; opc["addiu"] = 0x09;
		opc["and"] = 0; opc["or"] = 0;
		opc["xor"] = 0; opc["nor"] = 0;
		opc["andi"] = 0x0c;
		opc["sll"] = 0; opc["srl"] = 0; opc["sra"] = 0;
		opc["slt"] = 0; opc["slti"] = 0x0a; opc["sltiu"] = 0x0b;
		opc["beq"] = 0x04; opc["bne"] = 0x05;
		opc["blez"] = 0x06; opc["bgtz"] = 0x07;
		opc["bltz"] = 0x01;
		opc["j"] = 0x02; opc["jal"] = 0x03;
		opc["jr"] = 0; opc["jalr"] = 0;
	}
	//ins_funct
	{	
		funct["add"] = 0x20; funct["addu"] = 0x21;
		funct["sub"] = 0x22; funct["subu"] = 0x23;
		funct["and"] = 0x24; funct["or"] = 0x25;
		funct["xor"] = 0x26; funct["nor"] = 0x27;
		funct["sll"] = 0; funct["srl"] = 0x02;
		funct["sra"] = 0x03; funct["slt"] = 0x2a;
		funct["jr"] = 0x08; funct["jalr"] = 0x09;
	}
	//ins_type
	//rs	rt	offset				0
	type["lw"] = type["sw"] = 0;
	//rs	rt	rd	0		funct	1
	type["add"] = type["addu"] = type["sub"] = type["subu"]
		= type["and"] = type["or"] = type["xor"] = type["nor"]
		= type["slt"] = type["sltu"] = 1;
	//rs	rt	rd	imm				2
	type["addi"] = type["addiu"] = type["andi"] = type["slti"]
		= type["sltiu"] = 2;
	//0		rt	rd	shamt	funct	3
	type["sll"] = type["srl"] = type["sra"] = 3;
	//4
	type["beq"] = type["bne"] = 4;
	//5
	type["blez"] = type["bgtz"] = type["bltz"] = 5;
	//6
	type["lui"] = 6;
	
	int pleft = 0;
	int pright = 0;
	int offset = 0;
	string temp = "";
	string slice = "";
	int pin = 0;
	int PC = -1;	//start with 0
	ifstream inf("code.txt", ios_base::in);
	for (;;) {
		getline(inf, temp);
		if (inf.fail()) break;
		//注释(优先级最高), empty line
		if (temp.length() == 0 || temp[0] == '#')
			continue;
		//行内注释
		pin = temp.find('#');
		temp = temp.substr(0, pin);
		//Label
		if (temp[temp.length() - 1] == ':') {
			Labels.push_back(Label_PC(temp.substr(0, temp.length() - 1), PC + 1));
			continue;
		}
		//行内标签
		pin = temp.find(':');
		if (pin != -1) {
			Labels.push_back(Label_PC(temp.substr(0, pin), PC + 1));
			temp = temp.substr(pin + 1, -1);
		}
		PC++;
		//行间断
		pin = mymin(temp.find(','), temp.find('\t'), temp.find(' '));
		while (pin != -1) {
			slice = temp.substr(0, pin);
			if (slice.length() > 0)
				Words.push_back(slice);
			temp = temp.substr(pin + 1);
			pin = mymin(temp.find(','), temp.find('\t'), temp.find(' '));
		}
		if(temp.length()>0)
			Words.push_back(temp);
	}
	inf.clear();
	inf.close();
	
	//for test
	//for (int i = 0; i < Labels.size(); i++)
	//	cout << Labels[i].Label << ' ' << Labels[i].PC << endl;

	PC = -1;
	ofstream outf("mcode.txt", ios_base::trunc);
	for (int i = 0; i < Words.size(); i++) {
		//for test
		//cout << Words[i] << ' ' << Words[i + 1] << ' ' << Words[i + 2] << ' ' << Words[i + 3] << endl;

		if (Words[i].compare("nop") == 0) {
			PC++;
			outf << PC << ": Instruction <= 32'b" << "00000000000000000000000000000000" << ';' << endl;
			cout << PC << ": Instruction <= 32'b" << "00000000000000000000000000000000" << ';' << endl;
		}
		else if (Words[i].compare("lui") == 0) {
			PC++;
			outf << PC << ": Instruction <= 32'b" << "001111" << "00000" << rb5(Words[i + 1]) << ib16(Words[i + 2]) << ';' << endl;
			cout << PC << ": Instruction <= 32'b" << "001111" << "00000" << rb5(Words[i + 1]) << ib16(Words[i + 2]) << ';' << endl;
			i += 2;
		}
		else if (Words[i].compare("j") == 0 || Words[i].compare("jal") == 0) {
			PC++;
			for (int j = 0; j < Labels.size(); j++) {
				if (Words[i + 1].compare(Labels[j].Label) == 0) {
					offset = Labels[j].PC;
					break;
				}
			}
			outf << PC << ": Instruction <= 32'b" << ob6(Words[i]) << bin26(offset) << ';' << endl;
			cout << PC << ": Instruction <= 32'b" << ob6(Words[i]) << bin26(offset) << ';' << endl;
			i += 1;
		}
		else if (Words[i].compare("jr") == 0) {
			PC++;
			outf << PC << ": Instruction <= 32'b" << "000000" << rb5(Words[i + 1]) << "000000000000000001000" << ';' << endl;
			cout << PC << ": Instruction <= 32'b" << "000000" << rb5(Words[i + 1]) << "000000000000000001000" << ';' << endl;
			i += 1;
		}
		else if (Words[i].compare("jalr") == 0) {
			PC++;
			outf << PC << ": Instruction <= 32'b" << "000000" << rb5(Words[i + 2]) << "00000" << rb5(Words[i + 1]) << "00000001001" << ';' << endl;
			cout << PC << ": Instruction <= 32'b" << "000000" << rb5(Words[i + 2]) << "00000" << rb5(Words[i + 1]) << "00000001001" << ';' << endl;
			i += 1;
		}
		else {
			switch (type[Words[i]]) {
			case 0:
				PC++;
				pleft = Words[i + 2].find('(');
				pright = Words[i + 2].find(')');
				outf << PC << ": Instruction <= 32'b" << ob6(Words[i]) << rb5(Words[i + 2].substr(pleft + 1, pright - pleft - 1))
					<< rb5(Words[i + 1]) << ib16(Words[i + 2].substr(0, pleft)) << ';' << endl;
				cout << PC << ": Instruction <= 32'b" << ob6(Words[i]) << rb5(Words[i + 1].substr(pleft + 1, pright - pleft - 1))
					<< rb5(Words[i + 1]) << ib16(Words[i + 1].substr(0, pleft)) << ';' << endl;
				i += 2;
				break;
			case 1:
				PC++;
				outf << PC << ": Instruction <= 32'b" << "000000" << rb5(Words[i + 2]) << rb5(Words[i + 3]) << rb5(Words[i + 1])
					<< "00000" << fb6(Words[i]) << ';' << endl;
				cout << PC << ": Instruction <= 32'b" << "000000" << rb5(Words[i + 2]) << rb5(Words[i + 3]) << rb5(Words[i + 1])
					<< "00000" << fb6(Words[i]) << ';' << endl;
				i += 3;
				break;
			case 2:
				PC++;
				outf << PC << ": Instruction <= 32'b" << ob6(Words[i]) << rb5(Words[i + 2]) << rb5(Words[i + 1]) << ib16(Words[i + 3]) << ';' << endl;
				cout << PC << ": Instruction <= 32'b" << ob6(Words[i]) << rb5(Words[i + 2]) << rb5(Words[i + 1]) << ib16(Words[i + 3]) << ';' << endl;
				i += 3;
				break;
			case 3:
				PC++;
				outf << PC << ": Instruction <= 32'b" << "000000" << "00000" << rb5(Words[i + 2]) << rb5(Words[i + 1]) << ib5(Words[i + 3]) << fb6(Words[i]) << ';' << endl;
				cout << PC << ": Instruction <= 32'b" << "000000" << "00000" << rb5(Words[i + 2]) << rb5(Words[i + 1]) << ib5(Words[i + 3]) << fb6(Words[i]) << ';' << endl;
				i += 3;
				break;
			case 4:
				//int offset;
				PC++;
				for (int j = 0; j < Labels.size(); j++) {
					if (Words[i + 3].compare(Labels[j].Label) == 0) {
						offset = Labels[j].PC - (PC + 1);
						break;
					}
				}
				outf << PC << ": Instruction <= 32'b" << ob6(Words[i]) << rb5(Words[i + 1]) << rb5(Words[i + 2]) << bin16(offset) << ';' << endl;
				cout << PC << ": Instruction <= 32'b" << ob6(Words[i]) << rb5(Words[i + 1]) << rb5(Words[i + 2]) << bin16(offset) << ';' << endl;
				i += 3;
				break;
			case 5:
				//int offset;
				PC++;
				for (int j = 0; j < Labels.size(); j++) {
					if (Words[i + 2].compare(Labels[j].Label) == 0) {
						offset = Labels[j].PC - (PC + 1);
						break;
					}
				}
				outf << PC << ": Instruction <= 32'b" << ob6(Words[i]) << rb5(Words[i + 1]) << "00000" << bin16(offset) << ';' << endl;
				cout << PC << ": Instruction <= 32'b" << ob6(Words[i]) << rb5(Words[i + 1]) << "00000" << bin16(offset) << ';' << endl;
				i += 2;
				break;
			default:
				cout << "error!!!" << endl;
				system("pause");
			}
		}
	}
	outf.close();
	system("pause");
	return 0;
}
