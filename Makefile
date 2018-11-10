DB=enceladus
BUILDDIR=${CURDIR}/build
BUILD=${BUILDDIR}/build.sql
SCRIPTS=${CURDIR}/scripts
CSV='${CURDIR}/cassini/data/master_plan.csv'
MASTER=${SCRIPTS}/import.sql
LOOKUP=${SCRIPTS}/lookuptables.sql
CLEANTABLES=${SCRIPTS}/cleantables.sql
NORMALIZE=${SCRIPTS}/normalize.sql

all: normalize
	psql $(DB) -f $(BUILD)

master:
	mkdir -p $(BUILDDIR)
	@cat $(MASTER) >> $(BUILD)

import: master
	@echo "COPY import.master_plan FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)

normalize: import
	@cat $(CLEANTABLES) >> $(BUILD)
	$(MAKE) createLookupTable TABLE=teams DESCRIPTIONCOL=team
	$(MAKE) createLookupTable TABLE=spass_types DESCRIPTIONCOL=spass_type
	$(MAKE) createLookupTable TABLE=targets DESCRIPTIONCOL=target
	$(MAKE) createLookupTable TABLE=event_types DESCRIPTIONCOL=library_definition
	$(MAKE) createLookupTable TABLE=requests DESCRIPTIONCOL=request_name
	@cat $(NORMALIZE) >> $(BUILD)

createLookupTable: 
	@cat $(LOOKUP) | sed 's/\[LOOKUP_TABLE\]/$(TABLE)/' | sed 's/\[THING\]/$(DESCRIPTIONCOL)/' >> $(BUILD)


clean:
	@rm -rf $(BUILDDIR)
