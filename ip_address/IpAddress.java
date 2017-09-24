public class IpAddress{
    private static byte CLASS_A_MASK = (byte) 0b10000000;
    private static byte CLASS_B_MASK = (byte) 0b11000000;
    private static byte CLASS_C_MASK = (byte) 0b11100000;
    private static byte CLASS_D_MASK = (byte) 0b11110000;

    private static byte CLASS_A_VALUE = (byte) 0b00000000;
    private static byte CLASS_B_VALUE = (byte) 0b10000000;
    private static byte CLASS_C_VALUE = (byte) 0b11000000;
    private static byte CLASS_D_VALUE = (byte) 0b11100000;

    private byte[] octets;

    public IpAddress(int o4, int o3, int o2, int o1){
        this.octets = new byte[4];
        this.octets[0] = (byte) o1;
        this.octets[1] = (byte) o2;
        this.octets[2] = (byte) o3;
        this.octets[3] = (byte) o4;
    }

    private static int makeUnsigned(byte b){
        int i = 0;
        i+=b;
        if(i<0){return i+128;}else{return i;}
    }

    public char getNetworkClass(){
        if((octets[3] & CLASS_A_MASK) == CLASS_A_VALUE){
            return 'A';
        }else if((octets[3] & CLASS_B_MASK) == CLASS_B_VALUE){
            return 'B';
        }else if((octets[3] & CLASS_C_MASK) == CLASS_C_VALUE){
            return 'C';
        }else if((octets[3] & CLASS_D_MASK) == CLASS_D_VALUE){
            return 'D';
        }else{
            return '\0';
        }
    }

    public void printNetworkInfo(int classChar){
        int f4,f3,f2,f1;
        String firstId="", lastId="", mask="";
        switch(classChar){
            case 'A':{
                firstId = "1.0.0.0";
                lastId = "126.0.0.0";
                mask = "255.0.0.0";
            }break;

            case 'B':{
                firstId = "128.0.0.0";
                lastId = "191.255.0.0";
                mask = "255.255.0.0";
            }break;

            case 'C':{
                firstId = "192.0.0.0";
                lastId = "223.255.255.0";
                mask = "255.255.255.0";
            }break;

            case 'D':{
                firstId = "255.0.0.0";
                lastId = "126.0.0.0";
                mask = "0.0.0.0";
            }break;
        }
        System.out.println("First ID: "+ firstId);
        System.out.println("Last ID: "+ lastId);
        System.out.println("Subnet Mask: "+ mask);
    }


    public static void main(String[] args){
        IpAddress address = new IpAddress(192, 168, 1, 100);
        char networkClass = address.getNetworkClass();
        System.out.println("CLass: "+networkClass);
        address.printNetworkInfo(networkClass);
    }
}
