#!/usr/bin/env python
import subprocess
import os.path


dpath = os.path.dirname(__file__)
if dpath:
  os.chdir(dpath)

if not os.path.exists('public'):
  os.makedirs('public')
robots = None
try:
  with open('public/robots.txt', 'wb') as robots:
    robots.write("""User-agent: *
Disallow: /
""")

  subprocess.check_call(['meteor', 'deploy', '--debug', 'chuckdemos.meteor.com'])
finally:
  if robots is not None:
    os.remove(robots.name)
