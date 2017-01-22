<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="utf-8"/>
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="page-unique"
                                       page-height="29.7cm"
                                       page-width="21cm"
                                       margin-top="0.5cm"
                                       margin-bottom="0.5cm"
                                       margin-left="2.5cm"
                                       margin-right="1cm">
                    <fo:region-body margin-top="1.6cm"
                                    margin-bottom="1.6cm">
                    </fo:region-body>
                    <fo:region-before extent="1.5cm">
                    </fo:region-before>
                    <fo:region-after extent="1.5cm">
                    </fo:region-after>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="page-unique"
                              font-family="Georgia"
                              background-color="#FFFFCC"
                              color="#000088">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block text-align="center"
                              font-weight="bold"
                              font-size="12pt">Facture de téléphone
                    </fo:block>
                </fo:static-content>
                <fo:static-content flow-name="xsl-region-after"
                                   text-align="center"
                                   font-style="italic"
                                   font-size="10pt">
                    <fo:block space-before="1em">Créé par Valentin Demeusy et Damien Douteaux
                    </fo:block>
                    <fo:block>Généré le <xsl:value-of select="//generationdate"/>
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body"
                         font-size="12pt"
                         font-family="Georgia"
                         font-style="italic"
                         text-align="justify">
                    <fo:block color="#008800"
                              font-size="14pt"
                              font-style="normal"
                              text-align="center">Liste des sms</fo:block>
                    <fo:table table-layout="fixed"
                              text-align="center"
                              space-before="1em"
                              width="100%">
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-header>
                            <fo:table-row>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Date</fo:block>
                                </fo:table-cell>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Volume</fo:block>
                                </fo:table-cell>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Destination</fo:block>
                                </fo:table-cell>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Zone</fo:block>
                                </fo:table-cell>

                            </fo:table-row>
                        </fo:table-header>
                        <fo:table-body>
                            <xsl:for-each select="//sms">
                                <fo:table-row>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="date"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="volume"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="destination"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="zone"/></fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>
                        </fo:table-body>
                    </fo:table>
                    <fo:block break-after="page"/>
                    <fo:block color="#008800"
                              font-size="14pt"
                              font-style="normal"
                              text-align="center">Liste des MMS</fo:block>

                    <fo:table table-layout="fixed"
                              text-align="center"
                              space-before="1em"
                              width="100%">
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-header>
                            <fo:table-row>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Date</fo:block>
                                </fo:table-cell>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Volume</fo:block>
                                </fo:table-cell>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Destination</fo:block>
                                </fo:table-cell>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Zone</fo:block>
                                </fo:table-cell>

                            </fo:table-row>
                        </fo:table-header>
                        <fo:table-body>
                            <xsl:for-each select="//mms">
                                <fo:table-row>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="date"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="volume"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="destination"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="zone"/></fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>
                        </fo:table-body>
                    </fo:table>

                    <fo:block break-after="page"/>

                    <fo:block color="#008800"
                              font-size="14pt"
                              font-style="normal"
                              text-align="center">Liste des appels</fo:block>

                    <fo:table table-layout="fixed"
                              text-align="center"
                              space-before="1em"
                              width="100%">
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-column column-width="proportional-column-width(1)">
                        </fo:table-column>
                        <fo:table-header>
                            <fo:table-row>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Date</fo:block>
                                </fo:table-cell>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Durée</fo:block>
                                </fo:table-cell>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Destination</fo:block>
                                </fo:table-cell>
                                <fo:table-cell
                                               border="0.5pt solid #CCCCCC"
                                               padding="2pt"
                                               color="#880000">
                                    <fo:block>Zone</fo:block>
                                </fo:table-cell>

                            </fo:table-row>
                        </fo:table-header>
                        <fo:table-body>
                            <xsl:for-each select="//appel">
                                <fo:table-row>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="date"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="duree"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="destination"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell border="0.5pt solid #CCCCCC" padding="2pt" display-align="center">
                                        <fo:block><xsl:value-of select="zone"/></fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>
                        </fo:table-body>
                    </fo:table>


                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
</xsl:stylesheet>
