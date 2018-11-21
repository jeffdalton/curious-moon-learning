Write-Host "Start $($MyInvocation.MyCommand.Name) @ $(Get-Date)"

$config=Get-Content -Path config/cassini_db_build.json -Raw | ConvertFrom-Json

# Prepare build settings
$db = $config.db
$build_dir = $config.build_dir
$script_dir = $config.script_dir
$drop_template = $config.template_dir + $config.drop_template
$lookup_template = $config.template_dir + $config.lookup_template
$drop_file = $build_dir + "drop_tables.sql"
$lookup_file = $build_dir + "build_lookup_tables.sql"
$import_file = $script_dir + "import.sql"
$build_file = $build_dir + "build.sql"

Write-Host "Target Database ${db}"

#Build Normalize Dynamic Scripts
ForEach($item in $config.normalize_tables) {
	$table = $item.table
	$column = $item.column
	Write-Host "Table: $table   Column: $column"
	(Get-Content $drop_template).Replace('[TABLE]', $table) | Add-Content $drop_File

	if ($item.isLookup)
	{
		Write-Host "Table IsLookup Is True.  Creating Lookup Script"
		(Get-Content $lookup_template).Replace('[TABLE]', $table).Replace('[COLUMN]', $column) |
			Add-Content $lookup_file
	}
}

#Write Initiatlize script to build file
Get-Content $import_file | Add-Content $build_file
 

# make clean
# if (!$?) {
# 	'Error occured'
# 	exit
# }



Write-Host "Normal End $($MyInvocation.MyCommand.Name) @ $(Get-Date)"
