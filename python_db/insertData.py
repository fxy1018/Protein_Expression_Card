import pymysql
import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, Numeric, String, Text, DateTime, Boolean, ForeignKey, Float
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, backref
from sqlalchemy import func
from sqlalchemy import and_, or_, not_
from datetime import datetime
import sys
import os.path
import pandas as pd
import re
from progress.bar import Bar
from createTable import *

def createSession(engine):
    conn = engine.connect()
    Session = sessionmaker(bind=conn, autoflush=False)
    session = Session()
    return session

###################insert table data#######################
class InsertMachine(object):
    def __init__(self, table, session):
        self.tableDict = {'info_source': InfoSource, 
                          'franchise': Franchise,
                          'organ': Organ,
                          'cell_type': CellType,
                          'primary': Primary,
                          'cell': Cell,
                          'species': Species,
                          'cell_source': CellSource,
                          'treatment': Treatment,
                          'assay_type': AssayType,
                          'assay': Assay,
                          'signal_strength': SignalStrength,
                          'antibody': Antibody,
                          'detail':Detail,
                          'eln': ELN,
                          'scientist': Scientist,
                          'item_type': ItemType,
                          'path': Path,
                          'experiment': Experiment
                          }
        
        self.tableObj = self.tableDict[table]
        self.table = table
        self.session = session
        
    def insertRecords(self, records):
        #input: a list of insert species
        bar = Bar('Progressing Insertion', max= len(records))  
        for r in records:
            isExist = self.session.query(self.tableObj.id).filter(self.tableObj.name == r).scalar()
            if not isExist:
                source = self.tableObj(name = r)
                self.session.add(source)
            bar.next()
            
        bar.finish()   
        self.session.commit()


class InsertMachineDetail(InsertMachine):
    def __init__(self, table, session):
        InsertMachine.__init__(self, table, session)
    def insertRecords(self, records):
        records = self.__parseRecord(records)
        #input: a list of insert species
        bar = Bar('Progressing Insertion', max= len(records))  
        for r in records:
            isExist = self.session.query(self.tableObj.id).filter(and_(self.tableObj.cGMP_level == r[0], self.tableObj.cell_number==r[1])).scalar()
            if not isExist:
                source = self.tableObj(cGMP_level = r[0], cell_number=r[1])
                self.session.add(source)
            bar.next()
            
        bar.finish()   
        self.session.commit()
    def __parseRecord(self, records):
        out = [r for r in records] 
        return(out)
 
class InsertMachineSignalStrength(InsertMachine):
    def __init__(self, table, session):
        InsertMachine.__init__(self, table, session)
        
    def insertRecords(self, records):
        valueDict = {'+': 3, '+++': 1, '-': 5, 'Y': 4, '++':2}
        #input: a list of insert species
        bar = Bar('Progressing Insertion', max= len(records))  
        for r in records:
            isExist = self.session.query(self.tableObj.id).filter(self.tableObj.name==r).scalar()
            if not isExist:
                source = self.tableObj(name = r, value=valueDict[r])
                self.session.add(source)
            bar.next()
            
        bar.finish()   
        self.session.commit()
        
        
class InsertMachineExperiment(InsertMachine):
    def __init__(self, table, session):
        InsertMachine.__init__(self, table, session)
        
    def insertRecords(self, records):
        bar = Bar('Progressing Insertion', max= len(records))  
        for r in records:
            exp = self.__getIds(r)
            source = self.tableObj(info_source_id = exp[0],
                                   franchise_id=exp[1],
                                   organ_id=exp[2],
                                   cell_type_id=exp[3],
                                   primary_id=exp[4],
                                   cell_id=exp[5],
                                   cell_annotation=exp[6],
                                   species_id=exp[7],
                                   cell_source_id=exp[8],
                                   treatment_id=exp[9],
                                   assay_type_id=exp[10],
                                   assay_id=exp[11],
                                   signal_strength_id=exp[12],
                                   antibody_id=exp[13],
                                   detail_id=exp[14],
                                   elns=exp[15],
                                   scientist_id=exp[16],
                                   comments=exp[17],
                                   item_type_id=exp[18],
                                   path_id=exp[19],
                                   date = exp[20]
                                   )
            self.session.add(source)
            bar.next()
            
        bar.finish()   
        self.session.commit()
    
    def __getIds(self,r):
        info_source_id = self.session.query(InfoSource.id).filter(InfoSource.name == r[0]).scalar()
        franchise_id=self.session.query(Franchise.id).filter(Franchise.name == r[1]).scalar()
        organ_id=self.session.query(Organ.id).filter(Organ.name == r[2]).scalar()
        cell_type_id= self.session.query(CellType.id).filter(CellType.name == r[3]).scalar()
        primary_id = self.session.query(Primary.id).filter(Primary.name == r[4]).scalar()
        cell_id = self.session.query(Cell.id).filter(Cell.name == r[5]).scalar()

        cell_annotation = self.__nullHelp(r[6])    
        species_id = self.session.query(Species.id).filter(Species.name == r[7]).scalar()
        cell_source_id = self.session.query(CellSource.id).filter(CellSource.name == r[8]).scalar()
      
        tmp_r = self.__nullHelp(r[9]) 
        treatment_id = self.session.query(Treatment.id).filter(Treatment.name == tmp_r).scalar()
        
        tmp_r = self.__nullHelp(r[10]) 
        assay_type_id = self.session.query(AssayType.id).filter(AssayType.name == tmp_r).scalar()
     
        tmp_r = self.__nullHelp(r[11]) 
        assay_id = self.session.query(Assay.id).filter(Assay.name == tmp_r).scalar()
        
        signal_strength_id = self.session.query(SignalStrength.id).filter(SignalStrength.name == r[12]).scalar()
        
        tmp_r = self.__nullHelp(r[13])
        antibody_id = self.session.query(Antibody.id).filter(Antibody.name == tmp_r).scalar()
        
        
        detail_id = self.session.query(Detail.id).filter(and_(Detail.cGMP_level == r[14], Detail.cell_number==r[15])).scalar()
            
        if not pd.isnull(r[16]):
            elns = r[16]
        else:
            elns = None
            
        scientist_id = self.session.query(Scientist.id).filter(Scientist.name == r[17]).scalar()
        
        comments = self.__nullHelp(r[18]) 
            
        item_type_id = self.session.query(ItemType.id).filter(ItemType.name == r[19]).scalar()
        path_id = self.session.query(Path.id).filter(Path.name == r[20]).scalar()
        date = self.__nullHelp(r[21])
        
        return([info_source_id, franchise_id, organ_id, cell_type_id, primary_id, cell_id, cell_annotation,
                 species_id, cell_source_id, treatment_id, assay_type_id, assay_id, signal_strength_id, antibody_id,
                  detail_id, elns, scientist_id, comments, item_type_id, path_id, date])
    
    def __nullHelp(self, r):
        return r if not pd.isnull(r) else None        