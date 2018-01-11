from createTable import *
from insertData import *
from insertData import InsertMachineDetail, InsertMachineSignalStrength, InsertMachineExperiment
import pandas as pd
import sys
import json


if __name__ == '__main__':
    local = ['root', '1234', 'localhost', 'protein_exp']
    serve = ['ironwood', 'irtest', '172.20.203.118:3306', 'protein_exp']
    serve_local = ['ironwood', 'irtest', 'localhost', 'protein_exp']
    server = serve_local
    #create tables
    engine = createEngine(*server)
    Base.metadata.create_all(engine)
    
    session = createSession(engine)

    try:
	    table = sys.argv[1]
	    data = json.loads(table.replace("'", '"'))[0]
	    
	    for t in data:
	    	if t not in ['signal_strength', 'cGMP_level', 'cell_number', 'eln', 'cell_annotation', 'comment', 'date']:
	    		if data[t]:
	    			insert_info = InsertMachine(t, session)
	    			insert_info.insertRecords([data[t]])
	    	if t =='eln' and data[t]:
	    		eln_list = data[t].split("|")
	    		insert_info = InsertMachine("eln", session)
	    		insert_info.insertRecords(eln_list)

	    cGMP_level = data['cGMP_level']
	    cell_number = data['cell_number']
	    if cGMP_level != "0" or cell_number != "0" :
	    	insert_info = InsertMachineDetail("detail", session)
	    	insert_info.insertRecords([[cGMP_level, cell_number]])



	    #################################################################
	    colnames = ('info_source', 'franchise','organ', 'cell_type','primary',
	                'cell', 'cell_annotation', 'species','cell_source','treatment','assay_type',
	                'assay','signal_strength', 'antibody','cGMP_level', 'cell_number', 'eln',
	                'scientist', 'comment', 'item_type','path','date')
	    exp = []
	    for c in colnames:
	    	exp.append(data[c])
	    
	    insert_info = InsertMachineExperiment("experiment", session)
	    insert_info.insertRecords([exp])

	    print("True")

    except:
    	print("False")
    finally:
    	session.close()
