function []=changeFileNames(folderPath)
regular_expression=...
'(\d+_\d+)_rg_(\d+_\d+)_mass_(\d+)_height_run(\d).xlsx';
for m=1:length(folderPath)
    matchingFilesXLSX=dir([folderPath{m} '*.xlsx']);
    matchingFilesXLS=dir([folderPath{m} '*.xls']);
    
    for n=1:length(matchingFilesXLSX)
        tokens=regexp(matchingFilesXLSX(n).name,regular_expression,'tokens');
        str_data=strrep(tokens{1},'_','.');
        
        r_old=str2num(str_data{1});
        m_old=str2num(str_data{2});
        h=str_data{3};
        run=str_data{4};
        r_new=[];
        m_new=[];
        
        found=true;
        %{
            if r_old==43.807 && m_old==508.2
                r_new=44.2322;
                m_new=785.7;
            elseif r_old==44.7 && m_old==1759.1
                r_new=44.1993;
                m_new=2460.7;
            elseif r_old==42.7592 && m_old==932.3
                r_new=42.8197;
                m_new=1633.9;
            elseif r_old==45.59 && m_old==710.6
                r_new=38.6288;
                m_new=988.1;
            elseif r_old==43.96 && m_old==1190.5
                r_new=39.6986;
                m_new=1892.1;
            elseif r_old==43.96 && m_old==1134.7
                r_new=39.9655;
                m_new=1836.3;
            end
        %}
        
        if r_old==38.6288 && m_old==988.1
                r_new=45.3632;
                m_new=716.5;
            elseif r_old==39.6986 && m_old==1892.1
                r_new=43.2141;
                m_new=1892.1;
            elseif r_old==39.9655 && m_old==1836.3
                r_new=43.2954;
                m_new=1564.7;
        else
            found=false;
        end
        
        if found
        
        r_new_str=strrep(num2str(r_new),'.','_');
        m_new_str=strrep(num2str(m_new),'.','_');
        
        new_str=[r_new_str '_rg_' m_new_str '_mass_' h '_height_run' run];
        new_str_xlsx=[new_str '.xlsx'];
        new_str_xls=[new_str '.xls'];
        
        movefile([matchingFilesXLSX(n).folder '/' matchingFilesXLSX(n).name],[folderPath{m} new_str_xlsx]);
        movefile([matchingFilesXLS(n).folder '/' matchingFilesXLS(n).name],[folderPath{m} new_str_xls]);
    
        disp(['Changed ' matchingFilesXLSX(n).name ' to:' new_str_xlsx]);
        
        end
    end
end
end