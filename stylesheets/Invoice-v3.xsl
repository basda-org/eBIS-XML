<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='1.0'  xmlns:HB='urn:schemas-basda-org:2001:eBUILD:1.00' xmlns:si='urn:schemas-basda-org:2000:salesInvoice:xdr:3.01' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
  <xsl:output encoding='iso-8859-1' method='html' />
<!--
****************************** WARNING *****************************************
  
  This stylesheet presupposes that the source XML contains the data necessary
  to produce a sensible invoice but the schema allows essential items to be
  ommitted.  It has been decided that to supply all the necessary checks here
  would be inappropriate. 
  
      - sjb, 20020103
  
********************************************************************************
  -->
<!--
TODO:
  - use currency - Euro
  - phone nos and email
  -->
  <xsl:template match='/'>
    <html>
      <head>
        <title>eBIS Invoice:
          <xsl:value-of select='/si:Invoice/si:InvoiceTo/si:Party' /> -
          <xsl:value-of select='/si:Invoice/si:InvoiceDate' />
        </title>
        <style type='text/css'>
          h1          { font-family:Tahoma ; font-size:18pt ; color:navy ; text-align:center ; font-weight:bold}
          table       { width : 100% }
          tr          { vertical-align : top }
          td          { font-size:10pt ; font-family:Tahoma }
          .sectTitle  { font-weight : bold }
          .addrTitle  { width:150 ; text-align:right ; font-weight:bold }
          .addr       { padding-left:10 ; padding-right:10 ; padding-top:5 ; padding-bottom:5 ; background-color : rgb(200,200,200) ; font-size : 12pt ; font-weight : bold}
          .summary    { font-weight : bold ; font-style : italic }
          .warn       { color:red ; font-style : italic }
        </style>
      </head>
      <body>
        <h1>Invoice</h1>
        <p>
          <TT style='color:red'>IMAGE GOES HERE</TT>
        </p>
        <xsl:apply-templates select='//si:Invoice' />
      </body>
    </html>
  </xsl:template>
  <xsl:template match='si:Invoice'>
    <table>
<!-- invoice header information -->
      <tr>
        <td>
          <table>
            <tr>
              <td class='addrTitle' style='width:150'>To:</td>
              <xsl:apply-templates select='si:InvoiceTo' />
              <td class='addrTitle' style='width:150'>From:</td>
              <xsl:apply-templates select='si:Supplier' />
            </tr>
            <tr>
              <td>&#160;</td>
              <xsl:apply-templates select='si:InvoiceTo/si:Contact' />
              <td>&#160;</td>
              <xsl:apply-templates select='si:Supplier/si:Contact' />
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td>&#160;</td>
      </tr>
      <tr>
        <td>
          <table>
            <tr>
              <td class='sectTitle'>Contract Order Ref:</td>
              <td>
                <xsl:value-of select='si:InvoiceReferences/si:ContractOrderReference' />
              </td>
              <td class='sectTitle'>Your Cost Centre:</td>
              <td>
                <xsl:value-of select='si:InvoiceReferences/si:CostCentre' />
                <xsl:if test='not(string-length(si:InvoiceReferences/si:CostCentre))'>
                  <div class='warn'>Missing essential data.</div>
                </xsl:if>
              </td>
            </tr>
            <tr>
              <td class='sectTitle'>Invoice Number:</td>
              <td>
                <xsl:value-of select='si:InvoiceReferences/si:SuppliersInvoiceNumber' />
                <xsl:if test='not(string-length(si:InvoiceReferences/si:SuppliersInvoiceNumber))'>
                  <div class='warn'>Missing essential data.</div>
                </xsl:if>
              </td>
              <td class='sectTitle'>Your Order No:</td>
              <td>
                <xsl:value-of select='si:InvoiceReferences/si:BuyersOrderNumber' />
                <xsl:if test='not(string-length(si:InvoiceReferences/si:BuyersOrderNumber))'>
                  <div class='warn'>Missing essential data.</div>
                </xsl:if>
              </td>
            </tr>
            <tr>
              <td class='sectTitle'>Invoice Date:</td>
              <td>
                <xsl:value-of select='si:InvoiceDate' />
                <xsl:if test='not(string-length(si:InvoiceDate))'>
                  <div class='warn'>Missing essential data.</div>
                </xsl:if>
              </td>
              <td class='sectTitle'>Your Project Code:</td>
              <td>
                <xsl:value-of select='si:InvoiceReferences/si:ProjectCode' />
                <xsl:if test='not(string-length(si:InvoiceReferences/si:ProjectCode))'>
                  <div class='warn'>Missing essential data.</div>
                </xsl:if>
              </td>
            </tr>
            <tr>
              <td>&#160;</td>
              <td>&#160;</td>
              <td class='sectTitle'>Your Supplier Code:</td>
              <td>
                <xsl:value-of select='si:Supplier/si:SupplierReferences/si:BuyersCodeForSupplier' />
                <xsl:if test='not(string-length(si:Supplier/si:SupplierReferences/si:BuyersCodeForSupplier))'>
                  <div class='warn'>Missing essential data.</div>
                </xsl:if>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td>&#160;
        </td>
      </tr>
      <tr>
        <td>
          <table border='1'>
<!-- line items -->
            <tr class='sectTitle'>
              <td>Line Number</td>
              <td>Quantity</td>
              <td>Product Code</td>
              <td>Product Description</td>
              <td>Price</td>
              <td>Percent Discount</td>
              <td>Amount Discount</td>
              <td>Tax Value</td>
              <td>Total</td>
            </tr>
            <xsl:apply-templates select='si:InvoiceLine' />
<!-- Invoice summary items -->
            <xsl:if test='si:PercentDiscount'>
              <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td class='sectTitle'>Discount on Total</td>
                <td class='summary'>
                  <xsl:value-of select='si:PercentDiscount/si:Percentage' />
                  <xsl:if test='not(string-length(si:PercentDiscount/si:Percentage))'>
                    &#160;
                  </xsl:if>
                </td>
                <td>&#160;</td>
                <td>&#160;</td>
                <td class='summary'>
                  <xsl:value-of select='si:AmountDiscount/si:Amount' />
                  <xsl:if test='not(string-length(si:PercentDiscount/si:Amount))'>
                    &#160;
                  </xsl:if>
                </td>
              </tr>
            </xsl:if>
            <tr>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td class='sectTitle'>Line Value Total</td>
              <td>&#160;</td>
              <td>&#160;</td>
              <td>&#160;</td>
              <td class='summary'>
                <xsl:value-of select='si:InvoiceTotal/si:LineValueTotal' />
                <xsl:if test='not(string-length(si:InvoiceTotal/si:LineValueTotal))'>
                  <div class='warn'>Missing TaxableTotal</div>
                </xsl:if>
              </td>
            </tr>
            <tr>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td class='sectTitle'>Total Tax</td>
              <td>&#160;</td>
              <td>&#160;</td>
              <td>&#160;</td>
              <td class='summary'>
                <xsl:value-of select='si:InvoiceTotal/si:TaxTotal' />
                <xsl:if test='not(string-length(si:InvoiceTotal/si:TaxTotal))'>
                  <div class='warn'>Missing</div>
                </xsl:if>
              </td>
            </tr>
            <tr>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td class='sectTitle'>Gross Total</td>
              <td>&#160;</td>
              <td>&#160;</td>
              <td>&#160;</td>
              <td class='summary'>
                <xsl:value-of select='si:InvoiceTotal/si:GrossPaymentTotal' />
                <xsl:if test='not(string-length(si:InvoiceTotal/si:GrossPaymentTotal))'>
                  <div class='warn'>Missing</div>
                </xsl:if>
              </td>
            </tr>
<!-- New Information: not required
  
<tr>
<td>
</td>
<td>
</td>
<td>
</td>
<td>
</td>
<td class='sectTitle'>Net Total
</td>
<td>&#160;
</td>
<td>&#160;
</td>
<td>&#160;
</td>
<td class='summary'>
<xsl:value-of select='si:InvoiceTotal/si:NetPaymentTotal' />
<xsl:if test='not(string-length(si:InvoiceTotal/si:NetPaymentTotal))'>
<div class='warn'>Missing
</div>
</xsl:if>
</td>
</tr>
  -->
          </table>
        </td>
      </tr>
      <tr>
        <td>&#160;</td>
      </tr>
<!-- invoice footer items -->
      <tr>
        <td>
          <div class='sectTitle'>For and on behalf of
            <xsl:choose>
              <xsl:when test='string-length(si:Supplier/si:Party)'>
                <xsl:value-of select='si:Supplier/si:Party' />
              </xsl:when>
              <xsl:when test='string-length(si:Supplier/si:Contact/si:Name)'>
                <xsl:value-of select='si:Supplier/si:Contact/si:Name' />
              </xsl:when>
              <xsl:otherwise>
                <div class='warn'>Missing supplier's name.</div>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
      </tr>
      <xsl:if test='si:SpecialInstructions|si:Narrative'>
        <tr>
          <td>
            <table>
              <xsl:apply-templates select='si:SpecialInstructions|si:Narrative' />
            </table>
          </td>
        </tr>
      </xsl:if>
    </table>
  </xsl:template>
  <xsl:template match='si:Address'>
    <span class='address'>
      <xsl:for-each select='si:AddressLine'>
        <div>
          <xsl:value-of select='.' />
        </div>
      </xsl:for-each>
      <xsl:for-each select='si:Street'>
        <div>
          <xsl:value-of select='.' />
        </div>
      </xsl:for-each>
      <div>
        <xsl:value-of select='si:City' />
      </div>
      <div>
        <xsl:value-of select='si:State' />
      </div>
      <div>
        <xsl:value-of select='si:Postcode' />
      </div>
      <div>
        <xsl:value-of select='si:Country' />
      </div>
    </span>
  </xsl:template>
  <xsl:template match='si:InvoiceLine'>
    <tr>
      <td>
        <xsl:value-of select='si:LineNumber' />
      </td>
      <td>
        <xsl:value-of select='si:Quantity/si:Amount' />
      </td>
      <td>
        <xsl:value-of select='si:Product/si:SuppliersProductCode' />
      </td>
      <td>
        <xsl:value-of select='si:Product/si:Description' />
      </td>
      <td>
        <xsl:value-of select='si:Price/si:UnitPrice' />
      </td>
      <td>
        <xsl:choose>
          <xsl:when test='string-length(si:PercentDiscount/si:Percentage)'>
            <xsl:value-of select='si:PercentDiscount/si:Percentage' />
          </xsl:when>
          <xsl:otherwise>
            &#160;
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test='string-length(si:AmountDiscount/si:Amount)'>
            <xsl:value-of select='si:AmountDiscount/si:Amount' />
          </xsl:when>
          <xsl:otherwise>
            &#160;
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test='string-length(si:LineTax/si:TaxValue)'>
            <xsl:value-of select='si:LineTax/si:TaxValue' />
          </xsl:when>
          <xsl:otherwise>
            &#160;
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test='si:LineTotal'>
            <xsl:value-of select='si:LineTotal' />
          </xsl:when>
          <xsl:otherwise>
            &#160;
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match='si:SpecialInstructions'>
    <tr>
      <td class='sectTitle' style='width : 150'>
        Special Instructions:
      </td>
      <td>&#160;</td>
    </tr>
    <tr>
      <td>&#160;</td>
      <td>
        <xsl:value-of select='.' />
      </td>
    </tr>
  </xsl:template>
  <xsl:template match='si:Narrative'>
    <tr>
      <td class='sectTitle' style='width : 150'>
        Notes: 
      </td>
      <td>&#160;</td>
    </tr>
    <tr>
      <td>&#160;</td>
      <td>
        <xsl:value-of select='.' />
      </td>
    </tr>
  </xsl:template>
  <xsl:template match='si:Supplier|si:Buyer|si:InvoiceTo'>
    <xsl:variable name='name' select='.//si:Contact/si:Name' />
    <xsl:variable name='party' select='.//si:Party' />
    <td class='addr' style='width:300'>
      <div>
        <xsl:value-of select='$name' />
      </div>
      <div>
        <xsl:value-of select='$party' />
      </div>
      <xsl:if test='not(string-length($party)) and not(string-length($name))'>
        <div class='warn'>Missing name and party.</div>
      </xsl:if>
      <div>
        <xsl:apply-templates select='.//si:Address' />
      </div>
    </td>
  </xsl:template>
  <xsl:template match='si:InvoiceTo/si:Contact|si:Buyer/si:Contact|si:Supplier/si:Contact'>
    <td class='addr' style='font-size:10pt'>
      <div>
          Tel:
        <xsl:if test='not(string-length(si:Switchboard))'>&#160;</xsl:if>
        <xsl:value-of select='si:Switchboard' />
      </div>
      <div>
          Fax:
        <xsl:if test='not(string-length(si:Fax))'>&#160;</xsl:if>
        <xsl:value-of select='si:Fax' />
      </div>
      <div>
          Email:
        <xsl:if test='not(string-length(si:Email))'>&#160;</xsl:if>
        <xsl:value-of select='si:Email' />
      </div>
    </td>
  </xsl:template>
</xsl:stylesheet>
