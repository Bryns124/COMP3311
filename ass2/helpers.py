# COMP3311 22T3 Assignment 2 ... Python helper functions
# add here any functions to share between Python scripts 
# you must submit this even if you add nothing

import re
import sys

# check whether a string looks like a year value
# return the integer value of the year if so

def printCountriesMakeDataQ2(res, movieYear):
   data = []
   for tup in res:
      if re.search("^[0-9]{4}$", str(tup[1])) and re.search("^[0-9]{4}$", movieYear):
         print(tup[2])
      else:
         sys.exit("Invalid year")
      data.append(tup)
   return data

def validityCheckQ2(data):
   if len(data) == 0:
      print("No such movie")
      sys.exit()
   else:
      for tup in data:
         if tup[1] == None:
            print("No releases")
            sys.exit()

def validityCheckQ3(res, year):
   if re.search("^[0-9]{4}$", year) == None:
      print("Invalid year")
      sys.exit()
   else:
      if len(res) == 0:
         print("No movies")
         sys.exit()

def makeDictQ4(res):
   peopleDict = {}
   for tup in res:
      if tup[0] in peopleDict:
         peopleDict[tup[0]].append((tup[1], tup[2], tup[3], tup[4], tup[5]))
      else:
         peopleDict[tup[0]] = [(tup[1], tup[2], tup[3], tup[4], tup[5])]
   return peopleDict

def printDictQ4_single(dict):
   isActor = False
   for key, values in dict.items():
      for value in values:
         if value[-1] == "actor" or value[-1] == "actress" or value[-1] == "self":
            isActor = True
            print(f"{value[1]} in {value[2]} ({value[3]})")
      if isActor == False:
         print("No acting roles")

def printDictQ4_multi(dict, name):
   isActor = False
   i = 1
   for key, values in dict.items():
      print(f"{name} #{i}")
      for value in values:
         if value[-1] == "actor" or value[-1] == "actress" or value[-1] == "self":
            isActor = True
            print(f"{value[1]} in {value[2]} ({value[3]})")
         else:
            isActor = False
      if isActor == False:
         print("No acting roles")
      i += 1

def executeQ5(title, year, cur):
   print(f"{title} ({year})")
   queryMovies = f"""
                  select people.name, playsrole.role, principals.job 
                  from principals left outer join playsrole on playsrole.inmovie = principals.id, movies, people
                  where principals.movie = movies.id and principals.person = people.id 
                  and movies.title = '{title}'
                  order by principals.ord;
                  """
   cur.execute(queryMovies)
   printPrincipalsQ5(cur.fetchall())

def printPrincipalsQ5(res):
   for tup in res:
      if tup[1] != None and (tup[-1] == "actor" or tup[-1] == "actress" or tup[-1] == "self"):
         print(f"{tup[0]} plays {tup[1]}")
      elif tup[1] == None and (tup[-1] == "actor" or tup[-1] == "actress" or tup[-1] == "self"):
         print(f"{tup[0]} plays ???")
      else:
         print(f"{tup[0]}: {tup[-1]}")