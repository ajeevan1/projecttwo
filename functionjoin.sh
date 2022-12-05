#!/usr/bin/env python

from sqlalchemy import create_engine

from sqlalchemy import MetaData

from sqlalchemy import Table, Column

from sqlalchemy import Integer, String

from sqlalchemy import sql, select, join, desc

from sqlalchemy import and_

import string


# Creating a Engine object which is our handle into the database.

engine = create_engine('sqlite:///world.sqlite')

# Connecting to the database

conn = engine.connect()



# Read the metadata from the existing database.

#  Since the database already exists and has tables defined, we can create Python objects based on these automatically.

DBInfo=MetaData(engine)

# Auto-creating the country,city and language object basedon the metadata read into the DBInfo.

country=Table('country', DBInfo, autoload=True)

city=Table('city', DBInfo, autoload=True)

language=Table('countrylanguage', DBInfo, autoload=True)

##**Using join**
##1. User inputs country of their choice
##2. Function binds the country table and countrylanguage table and extracts only the official language of that country from countrylanguage table
##3. Finally the result shows details of the inputted country with added official language detail from the countrylanguage table


inp = input('Enter country of choice (please enter full name of the country you are interested):') 

inp1=string.capwords(inp)





if len(inp1)!= 0:

    query=(select([country.c.Name, country.c.Continent,country.c.IndepYear,country.c.Population,country.c.GovernmentForm, language.c.Language])\

      .select_from(country.join(language)).where(and_(country.c.Name==inp1, language.c.IsOfficial=='T'))\

      .order_by(desc(country.c.Population)))

    result = conn.execute(query)

    for row in result:

        print('Country, Continent, Year of independence,Population,Form of the Government and Official langugage of',inp1, 'respectively is:')

        print(row)
