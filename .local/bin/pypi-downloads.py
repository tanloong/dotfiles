#!/usr/bin/env python3
# -*- coding=utf-8 -*-
"""
Author: Samarth Chitgopekar (github: http-samc)
"""

# Run this file and enter the package name when prompted to get the statistics!
# The only required external library is requests (get it with 'pip install requests')
import requests, json

package_name = input("PyPi Package Name: ")

r = requests.get(f"https://pypistats.org/api/packages/{package_name}/overall")

data = json.loads(r.text)["data"]

num_downloads = 0

for day in data:
    num_downloads += day["downloads"]

print(f"{package_name} got { format(num_downloads, ',') } downloads since being published { len(data) } days ago! (avg. { round(num_downloads/len(data), 3) } downloads/day)")
