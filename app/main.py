from typing import List
from sqlalchemy import text
from app.database import SessionLocal
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

app = FastAPI(
    title="Cofinga API",
    description="Plataforma de gestión de comunidades de propietarios",
    version="1.0.0"
)

# =========================
# MODELOS
# =========================

class CommunityCreate(BaseModel):
    name: str = Field(..., min_length=3, max_length=100)
    address: str = Field(..., min_length=5, max_length=200)


class Community(CommunityCreate):
    id: int


class PropertyCreate(BaseModel):
    community_id: int
    owner: str = Field(..., min_length=3, max_length=100)
    meters: float = Field(..., gt=0)


class Property(PropertyCreate):
    id: int


class AssessmentCreate(BaseModel):
    community_id: int
    amount: float = Field(..., gt=0)


class Assessment(AssessmentCreate):
    id: int


# =========================
# BASE DE DATOS EN MEMORIA
# =========================

communities: List[Community] = []
properties: List[Property] = []
assessments: List[Assessment] = []

next_community_id = 1
next_property_id = 1
next_assessment_id = 1


# =========================
# ENDPOINTS BÁSICOS
# =========================

@app.get("/")
def root():
    return {
        "application": "Cofinga",
        "version": "1.0.0"
    }


@app.get("/health")
def health():
    return {
        "status": "OK"
    }


# =========================
# COMUNIDADES
# =========================

@app.get("/communities")
def get_communities():

    db = SessionLocal()

    try:

        result = db.execute(
            text(
                """
                SELECT
                    id,
                    name,
                    address
                FROM communities
                ORDER BY id
                """
            )
        )

        return [
            dict(row._mapping)
            for row in result
        ]

    finally:
        db.close()

@app.get("/communities/{community_id}", response_model=Community)
def get_community(community_id: int):

    for community in communities:
        if community.id == community_id:
            return community

    raise HTTPException(
        status_code=404,
        detail="Community not found"
    )


@app.post("/communities", response_model=Community, status_code=201)
def create_community(data: CommunityCreate):

    global next_community_id

    community = Community(
        id=next_community_id,
        name=data.name,
        address=data.address
    )

    communities.append(community)
    next_community_id += 1

    return community


@app.put("/communities/{community_id}", response_model=Community)
def update_community(
    community_id: int,
    data: CommunityCreate
):

    for index, community in enumerate(communities):

        if community.id == community_id:

            updated = Community(
                id=community_id,
                name=data.name,
                address=data.address
            )

            communities[index] = updated

            return updated

    raise HTTPException(
        status_code=404,
        detail="Community not found"
    )


@app.delete("/communities/{community_id}")
def delete_community(community_id: int):

    for index, community in enumerate(communities):

        if community.id == community_id:

            del communities[index]

            return {
                "message": "Community deleted"
            }

    raise HTTPException(
        status_code=404,
        detail="Community not found"
    )


# =========================
# VIVIENDAS
# =========================

@app.get("/properties", response_model=List[Property])
def get_properties():
    return properties


@app.post("/properties", response_model=Property, status_code=201)
def create_property(data: PropertyCreate):

    global next_property_id

    community_exists = any(
        c.id == data.community_id
        for c in communities
    )

    if not community_exists:
        raise HTTPException(
            status_code=404,
            detail="Community not found"
        )

    property_item = Property(
        id=next_property_id,
        community_id=data.community_id,
        owner=data.owner,
        meters=data.meters
    )

    properties.append(property_item)

    next_property_id += 1

    return property_item


# =========================
# DERRAMAS
# =========================

@app.get("/assessments", response_model=List[Assessment])
def get_assessments():
    return assessments


@app.post("/assessments", response_model=Assessment, status_code=201)
def create_assessment(data: AssessmentCreate):

    global next_assessment_id

    community_exists = any(
        c.id == data.community_id
        for c in communities
    )

    if not community_exists:
        raise HTTPException(
            status_code=404,
            detail="Community not found"
        )

    assessment = Assessment(
        id=next_assessment_id,
        community_id=data.community_id,
        amount=data.amount
    )

    assessments.append(assessment)

    next_assessment_id += 1

    return assessment


# =========================
# REPARTO DE DERRAMAS
# =========================

@app.get("/assessments/{assessment_id}/distribution")
def calculate_distribution(assessment_id: int):

    assessment = next(
        (
            a for a in assessments
            if a.id == assessment_id
        ),
        None
    )

    if not assessment:
        raise HTTPException(
            status_code=404,
            detail="Assessment not found"
        )

    community_properties = [
        p for p in properties
        if p.community_id == assessment.community_id
    ]

    if not community_properties:
        raise HTTPException(
            status_code=400,
            detail="No properties registered"
        )

    total_meters = sum(
        p.meters
        for p in community_properties
    )

    distribution = []

    for prop in community_properties:

        amount = round(
            assessment.amount *
            (prop.meters / total_meters),
            2
        )

        distribution.append({
            "owner": prop.owner,
            "meters": prop.meters,
            "amount_to_pay": amount
        })

    return distribution
