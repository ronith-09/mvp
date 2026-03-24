#!/usr/bin/env bash

function createOrg1() {
  infoln "Enrolling the CA admin for BetweenOrganization"
  mkdir -p organizations/peerOrganizations/betweenorganization.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/betweenorganization.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-org1 --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/msp/config.yaml"

  mkdir -p "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/tlsca/tlsca.betweenorganization.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/ca"
  cp "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/ca/ca.betweenorganization.example.com-cert.pem"

  infoln "Registering peer0 for BetweenOrganization"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user for BetweenOrganization"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin for BetweenOrganization"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name betweenadmin --id.secret betweenadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp for BetweenOrganization"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/peers/peer0.betweenorganization.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  cp "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/peers/peer0.betweenorganization.example.com/msp/config.yaml"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/peers/peer0.betweenorganization.example.com/tls" --enrollment.profile tls --csr.hosts peer0.betweenorganization.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  cp "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/peers/peer0.betweenorganization.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/peers/peer0.betweenorganization.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/peers/peer0.betweenorganization.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/peers/peer0.betweenorganization.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/peers/peer0.betweenorganization.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/peers/peer0.betweenorganization.example.com/tls/server.key"

  infoln "Generating the user msp for BetweenOrganization"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-org1 -M "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/users/User1@betweenorganization.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/users/User1@betweenorganization.example.com/msp/config.yaml"

  infoln "Generating the org admin msp for BetweenOrganization"
  set -x
  fabric-ca-client enroll -u https://betweenadmin:betweenadminpw@localhost:7054 --caname ca-org1 -M "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/users/Admin@betweenorganization.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/betweenorganization.example.com/users/Admin@betweenorganization.example.com/msp/config.yaml"
}

function createOrg2() {
  infoln "Enrolling the CA admin for Bank1Organization"
  mkdir -p organizations/peerOrganizations/bank1organization.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/bank1organization.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-org2 --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/bank1organization.example.com/msp/config.yaml"

  mkdir -p "${PWD}/organizations/peerOrganizations/bank1organization.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/org2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/bank1organization.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/bank1organization.example.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/org2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/bank1organization.example.com/tlsca/tlsca.bank1organization.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/bank1organization.example.com/ca"
  cp "${PWD}/organizations/fabric-ca/org2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/bank1organization.example.com/ca/ca.bank1organization.example.com-cert.pem"

  infoln "Registering peer0 for Bank1Organization"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user for Bank1Organization"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin for Bank1Organization"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name bank1admin --id.secret bank1adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp for Bank1Organization"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M "${PWD}/organizations/peerOrganizations/bank1organization.example.com/peers/peer0.bank1organization.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bank1organization.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/bank1organization.example.com/peers/peer0.bank1organization.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates for Bank1Organization"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M "${PWD}/organizations/peerOrganizations/bank1organization.example.com/peers/peer0.bank1organization.example.com/tls" --enrollment.profile tls --csr.hosts peer0.bank1organization.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bank1organization.example.com/peers/peer0.bank1organization.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/bank1organization.example.com/peers/peer0.bank1organization.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/bank1organization.example.com/peers/peer0.bank1organization.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/bank1organization.example.com/peers/peer0.bank1organization.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/bank1organization.example.com/peers/peer0.bank1organization.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/bank1organization.example.com/peers/peer0.bank1organization.example.com/tls/server.key"

  infoln "Generating the user msp for Bank1Organization"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-org2 -M "${PWD}/organizations/peerOrganizations/bank1organization.example.com/users/User1@bank1organization.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bank1organization.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/bank1organization.example.com/users/User1@bank1organization.example.com/msp/config.yaml"

  infoln "Generating the org admin msp for Bank1Organization"
  set -x
  fabric-ca-client enroll -u https://bank1admin:bank1adminpw@localhost:8054 --caname ca-org2 -M "${PWD}/organizations/peerOrganizations/bank1organization.example.com/users/Admin@bank1organization.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bank1organization.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/bank1organization.example.com/users/Admin@bank1organization.example.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy orderer org's CA cert to orderer org's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  # Copy orderer org's CA cert to orderer org's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem"

# Loop through each orderer (orderer, orderer2, orderer3, orderer4) to register and generate artifacts
  for ORDERER in orderer orderer2 orderer3 orderer4; do
    infoln "Registering ${ORDERER}"
    set -x
    fabric-ca-client register --caname ca-orderer --id.name ${ORDERER} --id.secret ${ORDERER}pw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
    { set +x; } 2>/dev/null

    infoln "Generating the ${ORDERER} MSP"
    set -x
    fabric-ca-client enroll -u https://${ORDERER}:${ORDERER}pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
    { set +x; } 2>/dev/null

    cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/msp/config.yaml"

    # Workaround: Rename the signcert file to ensure consistency with Cryptogen generated artifacts
    mv "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/msp/signcerts/cert.pem" "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/msp/signcerts/${ORDERER}.example.com-cert.pem"

    infoln "Generating the ${ORDERER} TLS certificates, use --csr.hosts to specify Subject Alternative Names"
    set -x
    fabric-ca-client enroll -u https://${ORDERER}:${ORDERER}pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls" --enrollment.profile tls --csr.hosts ${ORDERER}.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
    { set +x; } 2>/dev/null

    # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
    cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/ca.crt"
    cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/server.crt"
    cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/server.key"

    # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
    mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/msp/tlscacerts"
    cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
  done

  # Register and generate artifacts for the orderer admin
  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml"
}

function createBank2() {
  infoln "Enrolling the CA admin for Bank2Organization"
  mkdir -p organizations/peerOrganizations/bank2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/bank2.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9055 --caname ca-bank2 --tls.certfiles "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9055-ca-bank2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9055-ca-bank2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9055-ca-bank2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9055-ca-bank2.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/config.yaml"

  mkdir -p "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/cacerts"
  cp "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem" "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/cacerts/localhost-9055-ca-bank2.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem" "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/signcerts"
  if [ -f "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/signcerts/cert.pem" ]; then
    cp "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/signcerts/cert.pem" "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/signcerts/Admin@bank2.example.com-cert.pem"
  fi

  mkdir -p "${PWD}/organizations/peerOrganizations/bank2.example.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem" "${PWD}/organizations/peerOrganizations/bank2.example.com/tlsca/tlsca.bank2.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/bank2.example.com/ca"
  cp "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem" "${PWD}/organizations/peerOrganizations/bank2.example.com/ca/ca.bank2.example.com-cert.pem"

  infoln "Registering peer0 for Bank2Organization"
  set -x
  fabric-ca-client register --caname ca-bank2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user for Bank2Organization"
  set -x
  fabric-ca-client register --caname ca-bank2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin for Bank2Organization"
  set -x
  fabric-ca-client register --caname ca-bank2 --id.name bank2admin --id.secret bank2adminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp for Bank2Organization"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9055 --caname ca-bank2 -M "${PWD}/organizations/peerOrganizations/bank2.example.com/peers/peer0.bank2.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/bank2.example.com/peers/peer0.bank2.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates for Bank2Organization"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9055 --caname ca-bank2 -M "${PWD}/organizations/peerOrganizations/bank2.example.com/peers/peer0.bank2.example.com/tls" --enrollment.profile tls --csr.hosts peer0.bank2.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bank2.example.com/peers/peer0.bank2.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/bank2.example.com/peers/peer0.bank2.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/bank2.example.com/peers/peer0.bank2.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/bank2.example.com/peers/peer0.bank2.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/bank2.example.com/peers/peer0.bank2.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/bank2.example.com/peers/peer0.bank2.example.com/tls/server.key"

  infoln "Generating the user msp for Bank2Organization"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9055 --caname ca-bank2 -M "${PWD}/organizations/peerOrganizations/bank2.example.com/users/User1@bank2.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/bank2.example.com/users/User1@bank2.example.com/msp/config.yaml"

  infoln "Generating the org admin msp for Bank2Organization"
  set -x
  fabric-ca-client enroll -u https://bank2admin:bank2adminpw@localhost:9055 --caname ca-bank2 -M "${PWD}/organizations/peerOrganizations/bank2.example.com/users/Admin@bank2.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/bankc/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bank2.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/bank2.example.com/users/Admin@bank2.example.com/msp/config.yaml"
}
