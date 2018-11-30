#!/bin/bash
echo "Start $0 @ $(date)"

json_config="config/cassini_db_build.json"

function build_import_script () {
    import_template = $1; echo "import_template $import_template"
    import_file = $2; echo "import_file $import_file"
    build_file = $3; echo "build_file $build_file"
}

function build_normalize_script () {
    $tables_list = $1; echo "tables_list $tables_list"
    $drop_template = $2; echo "drop_template $drop_template"
    $lookup_template = $3; echo "lookup_template $lookup_template"
    $normalize_template = $4; echo "normalize_template $normalize_template"
    $build_file = $5; echo "build_file $build_file"
}

function get_json_value() {
    cat $json_config | jq --raw-output $1
}

#Prepare Build Settings
db=$(get_json_value '.db'); echo "db ${db}"
base_dir=${PWD};base_dir+="/"; echo "base_dir ${base_dir}"
build_dir=$(get_json_value '.build_dir');build_dir="${base_dir}${build_dir}"; echo "build_dir ${build_dir}"
template_dir=$(get_json_value '.template_dir');template_dir="${base_dir}${template_dir}";
drop_template=$(get_json_value '.drop_template');drop_template="${template_dir}${drop_template}"; echo "drop_template ${drop_template}"
lookup_template=$(get_json_value '.lookup_template');lookup_template="${template_dir}${lookup_template}"; echo "lookup_template ${lookup_template}"
import_template=$(get_json_value '.import_template');import_template="${template_dir}${import_template}"; echo "import_template ${import_template}"
normalize_template=$(get_json_value '.normalize_template');normalize_template="${template_dir}${normalize_template}"; echo "normalize_template ${normalize_template}"
import_file=$(get_json_value '.import_file');import_file="${base_dir}${import_file}"; echo "import_file ${import_file}"
build_file=$(get_json_value '.build_file');build_file="${build_dir}${build_file}"; echo "build_file ${build_file}"

if [ -d $build_dir ]; then
    rm -rf $build_dir
fi
mkdir $build_dir
if [ ! $? -eq 0 ]; then
    echo "Error End $0 @ $(date)"
    exit 1
fi

cat $import_template | sed 's,\[IMPORT_FILE\],'"${import_file}"',' >> $build_file