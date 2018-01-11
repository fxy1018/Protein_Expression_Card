import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, Numeric, String, Text, DateTime, Boolean, ForeignKey, Float, Date
from sqlalchemy.orm import sessionmaker, relationship, backref
from sqlalchemy.ext.declarative import declarative_base



# Return engine instances to create tables. 
def createEngine(user, password, ip, database):
    query = 'mysql+pymysql://' + user + ':' + str(password) + '@' + str(ip) + '/' + database + "?charset=utf8"
    try:
        engine = create_engine(query)
    except sqlalchemy.exc.DatabaseError:
        print("Can't connect mysql.")
    return engine

#create Base object
Base = declarative_base()

class InfoSource(Base):
    __tablename__ = 'info_source'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False, unique = True)

class Franchise(Base):
    __tablename__ = 'franchise'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False, unique = True)
    
class Organ(Base):
    __tablename__ = 'organ'
  
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique = True)

class CellType(Base):
    __tablename__ = 'cell_type'
  
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique = True)

class Primary(Base):
    __tablename__ = 'primary'
  
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique = True)

class Cell(Base):
    __tablename__ = 'cell'
  
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique = True)

class Species(Base):
    __tablename__= "species"
    
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique = True)

class CellSource(Base):
    __tablename__= "cell_source"
     
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique = True)
    
class Treatment(Base):
    __tablename__= "treatment"
     
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique = True)

class AssayType(Base):
    __tablename__= "assay_type"
     
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique = True)
 
class Assay(Base):
    __tablename__= "assay"
     
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique = True)
    
class SignalStrength(Base):
    __tablename__= "signal_strength"
     
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False, unique = True)
    value = Column(Integer, nullable=False)

class Antibody(Base):
    __tablename__= "antibody"
     
    id = Column(Integer, primary_key=True)
    name = Column(String(50))
    
class Detail(Base):
    __tablename__= "detail"
     
    id = Column(Integer, primary_key=True)
    cGMP_level = Column(String(50))
    cell_number = Column(String(50))
       
class ELN(Base):
    __tablename__= "eln"
     
    id = Column(Integer, primary_key=True)
    name = Column(String(50))   

class Scientist(Base):
    __tablename__= "scientist"
     
    id = Column(Integer, primary_key=True)
    name = Column(String(50))  
     
class ItemType(Base):
    __tablename__= "item_type"
     
    id = Column(Integer, primary_key=True)
    name = Column(String(50)) 
    
class Path(Base):
    __tablename__= "path"
     
    id = Column(Integer, primary_key=True)
    name = Column(String(50)) 
    
class Experiment(Base):
    __tablename__ = 'experiment'
    
    id = Column(Integer, primary_key=True)
    info_source_id = Column(Integer, ForeignKey('info_source.id')) 
    franchise_id = Column(Integer, ForeignKey('franchise.id')) 
    organ_id = Column(Integer, ForeignKey('organ.id')) 
    cell_type_id = Column(Integer, ForeignKey('cell_type.id')) 
    primary_id = Column(Integer, ForeignKey('primary.id')) 
    cell_id = Column(Integer, ForeignKey('cell.id'))
    cell_annotation = Column(String(2000)) 
    species_id = Column(Integer, ForeignKey('species.id')) 
    cell_source_id = Column(Integer, ForeignKey('cell_source.id')) 
    treatment_id = Column(Integer, ForeignKey('treatment.id')) 
    assay_type_id = Column(Integer, ForeignKey('assay_type.id')) 
    assay_id = Column(Integer, ForeignKey('assay.id')) 
    signal_strength_id = Column(Integer, ForeignKey('signal_strength.id')) 
    antibody_id = Column(Integer, ForeignKey('antibody.id')) 
    detail_id = Column(Integer, ForeignKey('detail.id')) 
    elns = Column(String(1000)) # eln array, sep by "|" 
    scientist_id = Column(Integer, ForeignKey('scientist.id')) 
    comments = Column(String(2000))
    item_type_id = Column(Integer, ForeignKey('item_type.id'))
    path_id = Column(Integer, ForeignKey('path.id'))
    date = Column(Date)
    