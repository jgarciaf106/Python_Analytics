import os
def main(root_folder, sub_dir_folder, folder_list, path):
    
    # Create directory
    try:
        # Create target Directory
        os.mkdir(path + root_folder)
        os.mkdir(path + root_folder + '/' + sub_dir_folder)
        print(f"Directory {root_folder} and {sub_dir_folder} created") 
    except FileExistsError:
        os.mkdir(path + root_folder + '/' + sub_dir_folder)
        print("Directory " , root_folder ,  " already exists")        
    
    for folder in folder_list:
        try:
            # Create target Directory
            os.mkdir(path + root_folder + '/' + sub_dir_folder + '/' + folder)
            print(f"Directory {folder} created") 
        except FileExistsError:
            print("Directory " , folder ,  " already exists") 
        
    
if __name__ == '__main__':
    path = "C:/Users/garciand/HP Inc/Dashboards - L1 Org D&I Dashboards/"
    root_folder = "FY22"
    sub_dir_folder = "Q2"
    folder_list = [
        '01  [CMP] - Marketing',
        '02  [FIN] - Finance  [CREW] - Corp Real Estate n Workplace  [GIP] - Global Indirect Procurement',
        '03  [GCOM] - Corp Affairs',
        '04  [HCCO] - Commercial Organization',
        '05  [HPGC] - Global Legal Affairs',
        '06  [HPHR] - Human Resources',
        '07  [HPIP] - Imaging and Printing',
        '08  [HPIT] - IT  [HTMO] - Transformation',
        '09  [HPTO] - Chief Technology Office',
        '10  [OPER] - Operations',
        '11  [PSYS] - Personal Systems',
        '12  [SNI] - Strategy n Incubation'
]
    main(root_folder, sub_dir_folder, folder_list, path)