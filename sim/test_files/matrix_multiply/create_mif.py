import random
import string
import math

def main():
    depth = 512
    width = 8
    address_radix = "HEX"
    data_radix = "BIN"
    padding = math.ceil(math.log(depth - 1, 2)/8)
    output_file = "memory_init.mif"
    address_data_pair = ["{0:0{1}x} : 00000001;".format(i,padding) for i in range((int)(depth/8))]
    with open(output_file, 'w') as f:
        f.write("DEPTH = {d};\nWIDTH = {w};\nADDRESS_RADIX = {ar};\nDATA_RADIX = {dr};\n".format(d=depth, w=width, ar=address_radix, dr=data_radix))
        f.write("CONTENT BEGIN\n")
        for line in address_data_pair:
            f.write(line + '\n')
        f.write("END;")
        f.close()

if __name__ == "__main__":
    main()

