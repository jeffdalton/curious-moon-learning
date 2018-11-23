Write-Host "Start $($MyInvocation.MyCommand.Name) @ $(Get-Date)"

function Build-Import-Script($import_template, $import_file, $build_file)
{
	Write-Output "Import Template $import_template"
	Write-Output "Import File $import_file"
	Write-Output "Build File $build_file"
	(Get-Content $import_template).Replace('[IMPORT_FILE]', $import_file) | 
	Add-Content $build_file
}

function Build-Normalize-Script($tables_list, $drop_template, $lookup_template, $normalize_template, $build_file)
{
	ForEach($item in $tables_list) {
		$table = $item.table
		$column = $item.column
		Write-Host "Table: $table   Column: $column"
		(Get-Content $drop_template).Replace('[TABLE]', $table) | Add-Content $build_file
	}

	ForEach($item in $tables_list) {
		if ($item.isLookup) {
			$table = $item.table
			$column = $item.column
			(Get-Content $lookup_template).Replace('[TABLE]', $table).Replace('[COLUMN]', $column) |
				Add-Content $build_file
		}
	}

	Get-Content $normalize_template | Add-Content $build_file

}

$config=Get-Content -Path config/cassini_db_build.json -Raw | ConvertFrom-Json

# Prepare build settings
$db = $config.db; Write-Host "db $db"
$base_dir = (Get-Location).ToString() + "/"; Write-Host "base_dir $base_dir"
$build_dir = $base_dir + $config.build_dir; Write-Host "build_dir $build_dir"
$drop_template = $base_dir + $config.template_dir + $config.drop_template; Write-Host "drop_template $drop_template" 
$lookup_template = $base_dir + $config.template_dir + $config.lookup_template; Write-Host "lookup_template $lookup_template"
$import_template = $base_dir + $config.template_dir + $config.import_template; Write-Host "import_template $import_template"
$normalize_template = $base_dir + $config.template_dir + $config.normalize_template; Write-Host "normalize_template $normalize_template"
$import_file = $base_dir + $config.import_file; Write-Host "import_file $import_file"
$build_file = $build_dir + $config.build_file; Write-Host "build_file $build_file"

if (Test-Path -Path $build_dir)
{
	Remove-Item $build_dir -Force -Recurse | Out-Null
}
New-Item -ItemType Directory -Force -Path $build_dir | Out-Null
if (!$?) {
	Write-Error "Error End $($MyInvocation.MyCommand.Name) @ $(Get-Date)"
	exit
}

Build-Import-Script $import_template $import_file $build_file
Build-Normalize-Script $config.normalize_tables $drop_template $lookup_template $normalize_template $build_file
psql -V ON_ERROR_STOP=1
psql $db -f $build_file 
if (!$?) {
	Write-Error "Error End $($MyInvocation.MyCommand.Name) @ $(Get-Date)"
	exit
}


Write-Host "Normal End $($MyInvocation.MyCommand.Name) @ $(Get-Date)"
