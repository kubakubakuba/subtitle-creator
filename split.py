import re
import sys

def extract_subs(input_file):
    subs = []
    with open(input_file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            matches = re.findall(r'(\d{2}:\d{2}:\d{2},\d{3}) --> (\d{2}:\d{2}:\d{2},\d{3})[^<]+<font color="#[a-f0-9]{6}">([^<]+)<\/font>', line)
            for match in matches:
                subs.append(match)
    return subs

def write_subs(subs, output_file):
    with open(output_file, 'w') as f:
        for idx, sub in enumerate(subs):
            f.write(str(idx))
            f.write('\n')
            f.write(f"{sub[0]} --> {sub[1]}")
            f.write('\n')
            f.write(sub[2])
            f.write('\n')
            f.write('\n')

subs = extract_subs(sys.argv[1])

write_subs(subs, sys.argv[1])

