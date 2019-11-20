#!/bin/bash

# directories
STORAGE_DIR="${HOME}/.aion"
LOG_DIR="${STORAGE_DIR}/log"
CURRENT_DATE=`date '+%Y-%m-%d_%H:%M:%S'`

mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/log_${CURRENT_DATE}"

echo "Removing old home folder jre install" &>> "${LOG_FILE}"
rm -fr "${STORAGE_DIR}/jre-10.0.2" &>> "${LOG_FILE}"

# get the directory of the currently executing script
SOURCE="${BASH_SOURCE[0]}"
while [[ -h "$SOURCE" ]]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "${SOURCE}" )" >/dev/null && pwd )"
  SOURCE="$(readlink "${SOURCE}")"
  [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

SCRIPT_PATH="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
echo "Located script directory: ${SCRIPT_PATH}" &>> "${LOG_FILE}"
cd "${SCRIPT_PATH}"

JAVA_INSTALL="${SCRIPT_PATH}/java"
JAVA_CMD="${JAVA_INSTALL}/bin/java"

MOD_DIR="${SCRIPT_PATH}/mod/*"
LIB_DIR="${SCRIPT_PATH}/lib/*"

"${JAVA_CMD}" -cp "${MOD_DIR}:${LIB_DIR}" -Dlocal.storage.dir="${STORAGE_DIR}" -Xms300m -Xmx500m org.aion.wallet.WalletApplication &>> "${LOG_FILE}" &
echo "Starting the OAN Wallet ..."