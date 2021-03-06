C-----------------------------------------------------------------------
      MODULE BACIO_MODULE
C$$$  F90-MODULE DOCUMENTATION BLOCK
C
C F90-MODULE: BACIO_MODULE   BYTE-ADDRESSABLE I/O MODULE
C   PRGMMR: IREDELL          ORG: NP23        DATE: 98-06-04
C
C ABSTRACT: MODULE TO SHARE FILE DESCRIPTORS
C   IN THE BYTE-ADDESSABLE I/O PACKAGE.
C
C PROGRAM HISTORY LOG:
C   98-06-04  IREDELL
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 90
C
C$$$
      INTEGER,EXTERNAL:: BACIO
      INTEGER,DIMENSION(999),SAVE:: FD=999*0
      INTEGER,DIMENSION(20),SAVE:: BAOPTS=0
      INCLUDE 'baciof.h'
      END

